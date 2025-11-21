import 'package:faithmood_app/core/core_exports.dart';

abstract class AnalyticsRepository {
  Future<Analytics?> getUserAnalytics(
    int userId,
    String startDate,
    String endDate,
  );
}

