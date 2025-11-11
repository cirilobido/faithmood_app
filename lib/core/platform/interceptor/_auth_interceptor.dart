import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:faithmood_app/core/core_exports.dart';
import 'package:faithmood_app/routes/app_routes.dart';
import 'package:faithmood_app/routes/app_routes_names.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../providers/data/data_sources/local/auth_dao.dart';

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(ref: ref, authDao: ref.watch(authDaoProvider));
});

class AuthInterceptor implements Interceptor {
  final Ref ref;
  final AuthDao authDao;
  final Dio _dio = Dio();

  AuthInterceptor({required this.ref, required this.authDao});

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final authToken = await authDao.getCurrentUserToken();
    var headers = {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/x-www-form-urlencoded",
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
          "Content-Type": "application/x-www-form-urlencoded",
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
        // TODO: Invalidate all viewmodels
        // ref.invalidate(homeViewModelProvider);
        await Purchases.logOut();
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
      final currentToken = await authDao.getCurrentUserToken();
      if (currentToken == null) return false;

      // final response = await authRepository.refreshToken(currentToken);
      final response = await _dio.post(
        "${Endpoints.base}${Endpoints.refreshToken}",
        data: {"token": currentToken},
        options: Options(
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data["token"];
        await authDao.saveCurrentUserToken(newAccessToken);
        return true;
      }
    } catch (e) {
      rethrow;
    }
    return false;
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
