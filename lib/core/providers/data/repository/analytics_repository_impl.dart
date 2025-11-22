import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../../../dev_utils/dev_utils_exports.dart';
import '../../domain/repository/analytics_repository.dart';
import '../data_sources/remote/analytics_service.dart';
import '../data_sources/local/analytics_dao.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl(
    ref.watch(analyticsServiceProvider),
    ref.watch(analyticsDaoProvider),
  );
});

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsService analyticsService;
  final AnalyticsDao analyticsDao;

  AnalyticsRepositoryImpl(this.analyticsService, this.analyticsDao);

  @override
  Future<Analytics?> getUserAnalytics(
    int userId,
    String startDate,
    String endDate,
  ) async {
    try {
      devLogger('AnalyticsRepository.getUserAnalytics() called - userId: $userId, startDate: $startDate, endDate: $endDate');
      final result = await analyticsService.getUserAnalytics(
        userId,
        startDate,
        endDate,
      );
      devLogger('AnalyticsRepository.getUserAnalytics() - service returned: ${result != null ? "data" : "null"}');
      return result;
    } catch (e) {
      devLogger('AnalyticsRepository.getUserAnalytics() - ERROR: $e');
      rethrow;
    }
  }
}

