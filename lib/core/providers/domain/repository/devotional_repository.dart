import 'package:faithmood_app/core/core_exports.dart';

abstract class DevotionalRepository {
  Future<Devotional?> getDailyDevotional(String lang);
}

