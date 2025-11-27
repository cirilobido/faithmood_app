import 'package:selah_app/core/core_exports.dart';

abstract class MoodRepository {
  Future<List<Mood>> getMoods(String lang);
  Future<MoodSessionResponse?> createMoodSession(int userId, MoodSessionRequest request);
  Future<MoodSessionsResponse?> getMoodSessions(int userId, Map<String, dynamic>? queryParams);
  Future<MoodSession?> getMoodSessionDetail(int userId, String sessionId, String lang);
  Future<bool> deleteMoodSession(int userId, String sessionId);
  Future<MoodSession?> updateMoodSession(int userId, String sessionId, MoodSessionRequest request);
}

