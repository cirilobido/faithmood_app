import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

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
    final analyticsJson = await secureStorage.getValue(
      key: _getAnalyticsKey(startDate, endDate),
    );
    if (analyticsJson == null) return null;
    try {
      final response = AnalyticsResponse.fromJson(jsonDecode(analyticsJson));
      return response.toAnalytics();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> saveAnalytics(Analytics analytics, String startDate, String endDate) async {
    try {
      await deleteAnalytics(startDate, endDate);
      
      final response = AnalyticsResponse(
        dailyStats: analytics.dailyStats,
        rangeStats: analytics.rangeStats,
        activityByDate: analytics.activityByDate,
      );
      
      final analyticsJsonEncoded = jsonEncode(response.toJson());
      await secureStorage.saveValue(
        key: _getAnalyticsKey(startDate, endDate),
        value: analyticsJsonEncoded,
      );
      return true;
    } catch (_) {
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

