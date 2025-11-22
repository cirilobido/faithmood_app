import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';
import '../../../../../dev_utils/dev_utils_exports.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return AnalyticsServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class AnalyticsService {
  Future<Analytics?> getUserAnalytics(
    int userId,
    String startDate,
    String endDate,
  );
}

class AnalyticsServiceImpl implements AnalyticsService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  AnalyticsServiceImpl({
    required this.httpClient,
    required this.requestProcessor,
  });

  @override
  Future<Analytics?> getUserAnalytics(
    int userId,
    String startDate,
    String endDate,
  ) async {
    try {
      final endpoint = Endpoints.getUserAnalytics(userId, startDate, endDate);
      devLogger('AnalyticsService.getUserAnalytics() called - endpoint: $endpoint');
      devLogger('AnalyticsService.getUserAnalytics() - full URL: ${httpClient.options.baseUrl}$endpoint');
      final request = await requestProcessor.process(
        request: httpClient.get(endpoint),
        jsonMapper: (data) {
          devLogger('AnalyticsService.getUserAnalytics() - response received, parsing...');
          final response = AnalyticsResponse.fromJson(
            data as Map<String, dynamic>,
          );
          return response.toAnalytics();
        },
      ) as Analytics?;
      devLogger('AnalyticsService.getUserAnalytics() - request completed successfully');
      return request;
    } on ConnectionError {
      rethrow;
    } catch (e, stackTrace) {
      devLogger('AnalyticsService.getUserAnalytics() - ERROR: $e');
      devLogger('AnalyticsService.getUserAnalytics() - StackTrace: $stackTrace');
      throw Exception('AnalyticsService error: $e');
    }
  }
}

