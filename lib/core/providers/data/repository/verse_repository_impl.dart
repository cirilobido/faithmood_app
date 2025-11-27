import 'package:selah_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/verse_repository.dart';
import '../data_sources/remote/verse_service.dart';
import '../data_sources/local/verse_dao.dart';

final verseRepositoryProvider = Provider<VerseRepository>((ref) {
  return VerseRepositoryImpl(
    verseService: ref.watch(verseServiceProvider),
    verseDao: ref.watch(verseDaoProvider),
  );
});

class VerseRepositoryImpl implements VerseRepository {
  final VerseService verseService;
  final VerseDao verseDao;

  VerseRepositoryImpl({
    required this.verseService,
    required this.verseDao,
  });

  /// Checks if the stored verse date is from today
  bool _isVerseFromToday(String? storedDate) {
    if (storedDate == null) return false;
    
    try {
      final storedDateParts = storedDate.split('-');
      if (storedDateParts.length != 3) return false;
      
      final storedYear = int.parse(storedDateParts[0]);
      final storedMonth = int.parse(storedDateParts[1]);
      final storedDay = int.parse(storedDateParts[2]);
      
      final today = DateTime.now();
      final todayYear = today.year;
      final todayMonth = today.month;
      final todayDay = today.day;
      
      // Check if stored date is today (before 12:00 AM means it's from today)
      // Since we store the date when verse was saved, we check if it matches today's date
      return storedYear == todayYear && 
             storedMonth == todayMonth && 
             storedDay == todayDay;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Verse?> getDailyVerse(String lang) async {
    try {
      // Check if we have a cached verse for today
      final cachedVerse = await verseDao.getDailyVerse(lang);
      final storedDate = await verseDao.getDailyVerseDateForLang(lang);
      
      // If we have a verse from today, return it (no API call needed)
      if (cachedVerse != null && _isVerseFromToday(storedDate)) {
        return cachedVerse;
      }
      
      // Otherwise, fetch new verse from API (it's a new day after 12:00 AM)
      try {
        final result = await verseService.getDailyVerse(lang);
        
        // Save the new verse for future use
        if (result != null) {
          await verseDao.saveDailyVerse(result, lang);
        }
        
        return result;
      } catch (apiError) {
        // If API call fails, fall back to cached verse (even if from previous day)
        if (cachedVerse != null) {
          return cachedVerse;
        }
        // If no cached verse and API fails, rethrow the error
        rethrow;
      }
    } catch (e) {
      throw Exception('Error getting daily verse from RIMP!');
    }
  }
}
