import 'package:faithmood_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/devotional_repository.dart';
import '../data_sources/remote/devotional_service.dart';
import '../data_sources/local/devotional_dao.dart';

final devotionalRepositoryProvider = Provider<DevotionalRepository>((ref) {
  return DevotionalRepositoryImpl(
    devotionalService: ref.watch(devotionalServiceProvider),
    devotionalDao: ref.watch(devotionalDaoProvider),
  );
});

class DevotionalRepositoryImpl implements DevotionalRepository {
  final DevotionalService devotionalService;
  final DevotionalDao devotionalDao;

  DevotionalRepositoryImpl({
    required this.devotionalService,
    required this.devotionalDao,
  });

  /// Checks if the stored devotional date is from today
  bool _isDevotionalFromToday(String? storedDate) {
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
      
      // Check if stored date is today (after 12:00 AM means it's a new day)
      // Since we store the date when devotional was saved, we check if it matches today's date
      return storedYear == todayYear && 
             storedMonth == todayMonth && 
             storedDay == todayDay;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Devotional?> getDailyDevotional(String lang) async {
    try {
      // Check if we have a cached devotional for today
      final cachedDevotional = await devotionalDao.getDailyDevotional(lang);
      final storedDate = await devotionalDao.getDailyDevotionalDateForLang(lang);
      
      // If we have a devotional from today, return it (no API call needed)
      if (cachedDevotional != null && _isDevotionalFromToday(storedDate)) {
        return cachedDevotional;
      }
      
      // Otherwise, fetch new devotional from API (it's a new day after 12:00 AM)
      try {
        final result = await devotionalService.getDailyDevotional(lang);
        
        // Save the new devotional for future use
        if (result != null) {
          await devotionalDao.saveDailyDevotional(result, lang);
        }
        
        return result;
      } catch (apiError) {
        // If API call fails, fall back to cached devotional (even if from previous day)
        if (cachedDevotional != null) {
          return cachedDevotional;
        }
        // If no cached devotional and API fails, rethrow the error
        rethrow;
      }
    } catch (e) {
      throw Exception('Error getting daily devotional from RIMP!');
    }
  }

  bool _isCacheValid(String? cachedDate) {
    if (cachedDate == null) return false;
    try {
      final cachedDateTime = DateTime.parse(cachedDate);
      final now = DateTime.now();
      final difference = now.difference(cachedDateTime);
      return difference.inDays < 7;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Devotional?> getDevotionalById(int id, String lang) async {
    try {
      final cachedDate = await devotionalDao.getDevotionalDetailsDate(id, lang);
      
      if (_isCacheValid(cachedDate)) {
        final cachedDevotional = await devotionalDao.getDevotionalDetails(id, lang);
        if (cachedDevotional != null) {
          return cachedDevotional;
        }
      }
      
      final result = await devotionalService.getDevotionalById(id, lang);
      
      if (result != null) {
        await devotionalDao.saveDevotionalDetails(result, id, lang);
      }
      
      return result;
    } catch (e) {
      final cachedDevotional = await devotionalDao.getDevotionalDetails(id, lang);
      if (cachedDevotional != null) {
        return cachedDevotional;
      }
      throw Exception('Error getting devotional by id');
    }
  }

  @override
  Future<DevotionalsResponse?> getDevotionalsByCategory(int categoryId, String lang, {int? page, int? limit}) async {
    try {
      final result = await devotionalService.getDevotionalsByCategory(categoryId, lang, page: page, limit: limit);
      
      if (result != null) {
        await devotionalDao.saveCategoryDevotionals(result, categoryId, lang);
      }
      
      return result;
    } catch (e) {
      final cachedResponse = await devotionalDao.getCategoryDevotionals(categoryId, lang);
      if (cachedResponse != null) {
        return cachedResponse;
      }
      throw Exception('Error getting category_devotionals by category_devotionals');
    }
  }

  @override
  Future<DevotionalsResponse?> getDevotionalsByTag(int tagId, String lang, {int? page, int? limit}) async {
    try {
      final result = await devotionalService.getDevotionalsByTag(tagId, lang, page: page, limit: limit);
      
      if (result != null) {
        await devotionalDao.saveCategoryDevotionals(result, 0, lang, tagId: tagId);
      }
      
      return result;
    } catch (e) {
      final cachedResponse = await devotionalDao.getCategoryDevotionals(0, lang, tagId: tagId);
      if (cachedResponse != null) {
        return cachedResponse;
      }
      throw Exception('Error getting category_devotionals by tag');
    }
  }

  @override
  Future<bool> saveDevotionalLog(int userId, DevotionalLogRequest request) async {
    try {
      return await devotionalService.saveDevotionalLog(userId, request);
    } catch (e) {
      throw Exception('Error saving devotional log');
    }
  }
}

