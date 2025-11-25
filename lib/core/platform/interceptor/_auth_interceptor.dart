import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faithmood_app/features/journal/_journal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:faithmood_app/core/core_exports.dart';
import 'package:faithmood_app/routes/app_routes.dart';
import 'package:faithmood_app/routes/app_routes_names.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../features/home/_home_view_model.dart';
import '../../../features/profile/_profile_view_model.dart';
import '../../providers/data/data_sources/local/auth_dao.dart';
import '../../providers/data/data_sources/local/analytics_dao.dart';

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(
    ref: ref, 
    authDao: ref.watch(authDaoProvider),
    analyticsDao: ref.watch(analyticsDaoProvider),
  );
});

class AuthInterceptor implements Interceptor {
  final Ref ref;
  final AuthDao authDao;
  final AnalyticsDao analyticsDao;
  final Dio _dio = Dio();

  AuthInterceptor({
    required this.ref, 
    required this.authDao,
    required this.analyticsDao,
  });

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final authToken = await authDao.getCurrentUserToken();
    var headers = {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/json",
    };
    options.headers.addAll(headers);

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      final errorMessage = err.response?.data['message'] ?? '';
      if (errorMessage != 'Unauthorized') return handler.next(err);
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newToken = (await authDao.getCurrentUserToken());

        final retryRequest = err.requestOptions;
        var headers = {
          "Authorization": "Bearer $newToken",
          "Content-Type": "application/json",
        };
        retryRequest.headers.addAll(headers);

        try {
          // final response = await dioProvider.fetch(retryRequest);
          final response = await _dio.fetch(retryRequest);
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(
            DioException(
              requestOptions: retryRequest,
              error: "Retry after refresh failed",
            ),
          );
        }
      } else {
        await authDao.deleteCurrentUser();
        await authDao.deleteCurrentUserToken();
        await authDao.deleteRefreshToken();
        await authDao.deleteRefreshExpiration();
        await authDao.deleteTokenExpiration();
        await analyticsDao.deleteAllAnalytics();
        ref.invalidate(homeViewModelProvider);
        ref.invalidate(profileViewModelProvider);
        ref.invalidate(journalViewModelProvider);
        
        // Log out from Purchases, handle anonymous user gracefully
        try {
          await Purchases.logOut();
        } catch (e) {
          // User may be anonymous, continue with logout flow
        }
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final router = GoRouter.of(
            AppRoutes.rootNavigatorKey.currentContext!,
          );
          router.go(Routes.initialPath);
        });
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'The user has been deleted or the session is expired',
          ),
        );
      }
    }

    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await authDao.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        "${Endpoints.base}${Endpoints.refreshToken}",
        data: {"refreshToken": refreshToken},
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final newToken = responseData["token"] as String?;
        final expiresIn = responseData["tokenExpiration"] as String?;
        final newRefreshToken = responseData["refreshToken"] as String?;
        final refreshExpiration = responseData["refreshExpiration"] as String?;

        if (newToken != null) {
          await authDao.saveCurrentUserToken(newToken);
          if (expiresIn != null) {
            await authDao.saveTokenExpiration(expiresIn);
          }
          if (newRefreshToken != null) {
            await authDao.saveRefreshToken(newRefreshToken);
          }
          if (refreshExpiration != null) {
            await authDao.saveRefreshExpiration(refreshExpiration);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseData = response.data;
    if (responseData is Map) {
      return handler.next(response);
    }
    return handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        error: 'The response is not in valid format',
      ),
    );
  }
}
