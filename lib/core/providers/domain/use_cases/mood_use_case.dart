import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/mood_repository_impl.dart';
import '../repository/mood_repository.dart';

final moodUseCaseProvider = Provider<MoodUseCase>(
  (ref) => MoodUseCase(ref.watch(moodRepositoryProvider)),
);

class MoodUseCase extends FutureUseCase<dynamic, dynamic> {
  final MoodRepository repository;

  MoodUseCase(this.repository);

  Future<Result<List<Mood>, Exception>> getMoods(String lang) async {
    try {
      final result = await repository.getMoods(lang);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<MoodSessionResponse?, Exception>> createMoodSession(int userId, MoodSessionRequest request) async {
    try {
      final result = await repository.createMoodSession(userId, request);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<MoodSessionsResponse?, Exception>> getMoodSessions(int userId, Map<String, dynamic>? queryParams) async {
    try {
      final result = await repository.getMoodSessions(userId, queryParams);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<MoodSession?, Exception>> getMoodSessionDetail(int userId, String sessionId, String lang) async {
    try {
      final result = await repository.getMoodSessionDetail(userId, sessionId, lang);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool, Exception>> deleteMoodSession(int userId, String sessionId) async {
    try {
      final result = await repository.deleteMoodSession(userId, sessionId);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<MoodSession?, Exception>> updateMoodSession(int userId, String sessionId, MoodSessionRequest request) async {
    try {
      final result = await repository.updateMoodSession(userId, sessionId, request);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}

