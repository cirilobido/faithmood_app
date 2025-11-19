import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final devotionalDaoProvider = Provider<DevotionalDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return DevotionalDaoImpl(secureStorage: secureStorage);
});

abstract class DevotionalDao {
  Future<bool?> saveDailyDevotional(Devotional params, String lang);
  Future<Devotional?> getDailyDevotional(String lang);
  Future<String?> getDailyDevotionalDate();
  Future<bool?> deleteDailyDevotional(String lang);
  Future<String?> getDailyDevotionalDateForLang(String lang);
  
  Future<bool?> saveDevotionalDetails(Devotional devotional, int id, String lang);
  Future<Devotional?> getDevotionalDetails(int id, String lang);
  Future<String?> getDevotionalDetailsDate(int id, String lang);
  Future<bool?> deleteDevotionalDetails(int id, String lang);
  
  Future<bool?> saveCategoryDevotionals(DevotionalsResponse response, int categoryId, String lang, {int? tagId});
  Future<DevotionalsResponse?> getCategoryDevotionals(int categoryId, String lang, {int? tagId});
  Future<bool?> deleteCategoryDevotionals(int categoryId, String lang, {int? tagId});
}

class DevotionalDaoImpl implements DevotionalDao {
  final SecureStorage secureStorage;

  DevotionalDaoImpl({required this.secureStorage});

  String _getDevotionalKey(String lang) => '${Constant.dailyDevotionalKey}_$lang';
  String _getDateKey(String lang) => '${Constant.dailyDevotionalDateKey}_$lang';
  
  String _getDevotionalDetailsKey(int id, String lang) => '${Constant.devotionalDetailsKey}_${id}_$lang';
  String _getDevotionalDetailsDateKey(int id, String lang) => '${Constant.devotionalDetailsDateKey}_${id}_$lang';
  
  String _getCategoryDevotionalsKey(int categoryId, String lang, {int? tagId}) {
    if (tagId != null) {
      return '${Constant.categoryDevotionalsKey}_tag_${tagId}_$lang';
    }
    return '${Constant.categoryDevotionalsKey}_category_${categoryId}_$lang';
  }

  @override
  Future<Devotional?> getDailyDevotional(String lang) async {
    final devotionalJson = await secureStorage.getValue(
      key: _getDevotionalKey(lang),
    );
    if (devotionalJson == null) return null;
    try {
      return Devotional.fromJson(jsonDecode(devotionalJson));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> saveDailyDevotional(Devotional params, String lang) async {
    final devotionalJsonEncoded = jsonEncode(params.toJson());
    await deleteDailyDevotional(lang);
    await secureStorage.saveValue(
      key: _getDevotionalKey(lang),
      value: devotionalJsonEncoded,
    );
    // Save the date when devotional was stored (YYYY-MM-DD format)
    final today = DateTime.now();
    final dateString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await secureStorage.saveValue(
      key: _getDateKey(lang),
      value: dateString,
    );
    return true;
  }

  @override
  Future<bool> deleteDailyDevotional(String lang) async {
    await secureStorage.deleteValue(key: _getDevotionalKey(lang));
    await secureStorage.deleteValue(key: _getDateKey(lang));
    return true;
  }

  @override
  Future<String?> getDailyDevotionalDate() async {
    // This method is not used, but kept for interface consistency
    // The date check is done in the repository with getDailyDevotionalDateForLang
    return null;
  }

  @override
  Future<String?> getDailyDevotionalDateForLang(String lang) async {
    final dateString = await secureStorage.getValue(
      key: _getDateKey(lang),
    );
    return dateString;
  }

  @override
  Future<bool> saveDevotionalDetails(Devotional devotional, int id, String lang) async {
    final devotionalJsonEncoded = jsonEncode(devotional.toJson());
    await deleteDevotionalDetails(id, lang);
    await secureStorage.saveValue(
      key: _getDevotionalDetailsKey(id, lang),
      value: devotionalJsonEncoded,
    );
    final now = DateTime.now().toIso8601String();
    await secureStorage.saveValue(
      key: _getDevotionalDetailsDateKey(id, lang),
      value: now,
    );
    return true;
  }

  @override
  Future<Devotional?> getDevotionalDetails(int id, String lang) async {
    final devotionalJson = await secureStorage.getValue(
      key: _getDevotionalDetailsKey(id, lang),
    );
    if (devotionalJson == null) return null;
    try {
      return Devotional.fromJson(jsonDecode(devotionalJson));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getDevotionalDetailsDate(int id, String lang) async {
    return await secureStorage.getValue(
      key: _getDevotionalDetailsDateKey(id, lang),
    );
  }

  @override
  Future<bool> deleteDevotionalDetails(int id, String lang) async {
    await secureStorage.deleteValue(key: _getDevotionalDetailsKey(id, lang));
    await secureStorage.deleteValue(key: _getDevotionalDetailsDateKey(id, lang));
    return true;
  }

  @override
  Future<bool> saveCategoryDevotionals(DevotionalsResponse response, int categoryId, String lang, {int? tagId}) async {
    final responseJsonEncoded = jsonEncode(response.toJson());
    await deleteCategoryDevotionals(categoryId, lang, tagId: tagId);
    await secureStorage.saveValue(
      key: _getCategoryDevotionalsKey(categoryId, lang, tagId: tagId),
      value: responseJsonEncoded,
    );
    return true;
  }

  @override
  Future<DevotionalsResponse?> getCategoryDevotionals(int categoryId, String lang, {int? tagId}) async {
    final responseJson = await secureStorage.getValue(
      key: _getCategoryDevotionalsKey(categoryId, lang, tagId: tagId),
    );
    if (responseJson == null) return null;
    try {
      return DevotionalsResponse.fromJson(jsonDecode(responseJson));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> deleteCategoryDevotionals(int categoryId, String lang, {int? tagId}) async {
    await secureStorage.deleteValue(
      key: _getCategoryDevotionalsKey(categoryId, lang, tagId: tagId),
    );
    return true;
  }
}

