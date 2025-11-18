import 'package:faithmood_app/core/core_exports.dart';

abstract class VerseRepository {
  Future<Verse?> getDailyVerse(String lang);
}
