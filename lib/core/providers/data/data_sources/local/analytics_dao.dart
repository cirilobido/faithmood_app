import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';
import '../../../../../dev_utils/dev_utils_exports.dart';

final analyticsDaoProvider = Provider<AnalyticsDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return AnalyticsDaoImpl(secureStorage: secureStorage);
});

abstract class AnalyticsDao {
  Future<bool> saveAnalytics(Analytics analytics, String startDate, String endDate);
  Future<Analytics?> getAnalytics(String startDate, String endDate);
  Future<bool> deleteAnalytics(String startDate, String endDate);
}

class AnalyticsDaoImpl implements AnalyticsDao {
  final SecureStorage secureStorage;

  AnalyticsDaoImpl({required this.secureStorage});

  String _getAnalyticsKey(String startDate, String endDate) =>
      '${Constant.analyticsKeyPrefix}_${startDate}_${endDate}';

  @override
  Future<Analytics?> getAnalytics(String startDate, String endDate) async {
    final key = _getAnalyticsKey(startDate, endDate);
    devLogger('AnalyticsDao.getAnalytics() - looking up key: $key');
    final analyticsJson = await secureStorage.getValue(key: key);
    if (analyticsJson == null) {
      devLogger('AnalyticsDao.getAnalytics() - no cached data found for key: $key');
      return null;
    }
    try {
      final response = AnalyticsResponse.fromJson(jsonDecode(analyticsJson));
      devLogger('AnalyticsDao.getAnalytics() - cached data found and parsed successfully');
      return response.toAnalytics();
    } catch (e) {
      devLogger('AnalyticsDao.getAnalytics() - error parsing cached data: $e');
      return null;
    }
  }

  @override
  Future<bool> saveAnalytics(Analytics analytics, String startDate, String endDate) async {
    try {
      final key = _getAnalyticsKey(startDate, endDate);
      devLogger('AnalyticsDao.saveAnalytics() - saving with key: $key');
      await deleteAnalytics(startDate, endDate);
      
      final response = AnalyticsResponse(
        dailyStats: analytics.dailyStats,
        rangeStats: analytics.rangeStats,
        activityByDate: analytics.activityByDate,
      );
      
      final analyticsJsonEncoded = jsonEncode(response.toJson());
      await secureStorage.saveValue(
        key: key,
        value: analyticsJsonEncoded,
      );
      devLogger('AnalyticsDao.saveAnalytics() - saved successfully with key: $key');
      return true;
    } catch (e) {
      devLogger('AnalyticsDao.saveAnalytics() - error saving: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteAnalytics(String startDate, String endDate) async {
    try {
      await secureStorage.deleteValue(key: _getAnalyticsKey(startDate, endDate));
      return true;
    } catch (_) {
      return false;
    }
  }
}

