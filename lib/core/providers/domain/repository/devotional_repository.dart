import 'package:faithmood_app/core/core_exports.dart';

abstract class DevotionalRepository {
  Future<Devotional?> getDailyDevotional(String lang);
  Future<Devotional?> getDevotionalById(int id, String lang);
  Future<DevotionalsResponse?> getDevotionalsByCategory(int categoryId, String lang, {int? page, int? limit});
  Future<DevotionalsResponse?> getDevotionalsByTag(int tagId, String lang, {int? page, int? limit});
  Future<bool> saveDevotionalLog(int userId, DevotionalLogRequest request);
}

