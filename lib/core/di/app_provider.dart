import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../platform/platform_exports.dart';
import '../static/static_exports.dart';

const _connectTimeoutDuration = Duration(seconds: 30);
const _receiveTimeoutDuration = Duration(seconds: 30);

final dioProvider = Provider<Dio>(
  (ref) => _generateDio(
    ref,
    Endpoints.base,
  ),
);

void _addInterceptors(Dio dio, Ref ref) {
  if (kDebugMode) {
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    ]);
  }
  final AuthInterceptor authenticationDao = ref.watch(authInterceptorProvider);
  dio.interceptors.add(authenticationDao);
}

Dio _generateDio(Ref ref, String baseUrl) {
  final client = Dio(
    BaseOptions(
      connectTimeout: _connectTimeoutDuration,
      receiveTimeout: _receiveTimeoutDuration,
      baseUrl: baseUrl,
    ),
  );
  _addInterceptors(client, ref);
  return client;
}

final requestProcessorProvider = Provider((ref) => RequestProcessor());
