import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selah_app/core/core_exports.dart';
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
    String endDate, {
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh) {
        final cachedAnalytics = await analyticsDao.getAnalytics(startDate, endDate);
        if (cachedAnalytics != null) {
          return cachedAnalytics;
        }
      }
      
      final result = await analyticsService.getUserAnalytics(
        userId,
        startDate,
        endDate,
      );
      
      if (result != null) {
        await analyticsDao.saveAnalytics(result, startDate, endDate);
      }
      
      return result;
    } on ConnectionError {
      final cachedAnalytics = await analyticsDao.getAnalytics(startDate, endDate);
      return cachedAnalytics;
    } catch (e) {
      devLogger('AnalyticsRepository.getUserAnalytics() - ERROR: $e');
      rethrow;
    }
  }
}

