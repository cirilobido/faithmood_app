import 'package:faithmood_app/core/core_exports.dart';

abstract class DevotionalRepository {
  Future<Devotional?> getDailyDevotional(String lang);
  Future<Devotional?> getDevotionalById(int id, String lang);
  Future<DevotionalsResponse?> getDevotionalsByCategory(int categoryId, String lang, {int? page, int? limit});
  Future<DevotionalsResponse?> getDevotionalsByTag(int tagId, String lang, {int? page, int? limit});
  Future<bool> saveDevotionalLog(int userId, DevotionalLogRequest request);
  Future<DevotionalLogsResponse?> getDevotionalLogs(int userId, Map<String, dynamic>? queryParams);
  Future<DevotionalLog?> getDevotionalLogDetail(int userId, int id, String lang);
  Future<DevotionalLog?> updateDevotionalLog(int userId, int id, DevotionalLogUpdateRequest request);
  Future<bool> deleteDevotionalLog(int userId, int id);
}

