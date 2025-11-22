import 'dart:io';

import 'package:dio/dio.dart';

import '../../core_exports.dart';

class RequestProcessor {
  Future<dynamic> process({
    required Future<dynamic> request,
    required Function(dynamic data) jsonMapper,
  }) async {
    try {
      final response = await request;
      if (response.statusCode == HttpStatus.ok) {
        final data = await jsonMapper.call(response.data);
        return data;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw TimeoutError('Request timeout: ${error.message}');
      }
      if (error.response != null) {
        final statusCode = error.response?.statusCode;
        if (statusCode == null) {
          throw Exception('No Status Code');
        }
        if (statusCode >= 500 && statusCode <= 599) {
          throw InternalServerError('Server error: ${error.message}');
        }
        if (statusCode == HttpStatus.tooManyRequests) {
          throw TooManyRequestsError('Too many requests');
        }
        if (statusCode == HttpStatus.notFound) {
          throw NotFoundError('No data found');
        }
      }
      throw Exception('Request error: ${error.message}');
    } catch (error) {
      rethrow;
    }
  }
}
