import 'package:faithmood_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/mood_repository.dart';
import '../data_sources/remote/mood_service.dart';
import '../data_sources/local/mood_dao.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepositoryImpl(
    moodService: ref.watch(moodServiceProvider),
    moodDao: ref.watch(moodDaoProvider),
  );
});

class MoodRepositoryImpl implements MoodRepository {
  final MoodService moodService;
  final MoodDao moodDao;

  MoodRepositoryImpl({required this.moodService, required this.moodDao});

  bool _isCacheValid(String? cachedDate) {
    if (cachedDate == null) return false;
    try {
      final cachedDateTime = DateTime.parse(cachedDate);
      final now = DateTime.now();
      final difference = now.difference(cachedDateTime);
      return difference.inDays < 15;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<Mood>> getMoods(String lang) async {
    try {
      final cachedDate = await moodDao.getMoodsDate(lang);

      if (_isCacheValid(cachedDate)) {
        final cachedMoods = await moodDao.getMoods(lang);
        if (cachedMoods != null && cachedMoods.isNotEmpty) {
          return cachedMoods;
        }
      }

      final result = await moodService.getMoods(lang);
      final moods = result?.moods ?? [];

      if (moods.isNotEmpty) {
        await moodDao.saveMoods(moods, lang);
      }

      return moods;
    } catch (apiError) {
      final cachedMoods = await moodDao.getMoods(lang);
      if (cachedMoods != null && cachedMoods.isNotEmpty) {
        return cachedMoods;
      }
      throw Exception('Error getting moods from RIMP!');
    }
  }

  @override
  Future<MoodSessionResponse?> createMoodSession(
    int userId,
    MoodSessionRequest request,
  ) async {
    try {
      return await moodService.createMoodSession(userId, request);
    } catch (e) {
      throw Exception('Error creating mood session');
    }
  }
}
