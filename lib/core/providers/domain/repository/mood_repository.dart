import 'package:faithmood_app/core/core_exports.dart';

abstract class MoodRepository {
  Future<List<Mood>> getMoods(String lang);
  Future<MoodSessionResponse?> createMoodSession(int userId, MoodSessionRequest request);
}

