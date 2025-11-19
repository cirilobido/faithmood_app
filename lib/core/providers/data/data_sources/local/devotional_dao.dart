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
}

class DevotionalDaoImpl implements DevotionalDao {
  final SecureStorage secureStorage;

  DevotionalDaoImpl({required this.secureStorage});

  String _getDevotionalKey(String lang) => '${Constant.dailyDevotionalKey}_$lang';
  String _getDateKey(String lang) => '${Constant.dailyDevotionalDateKey}_$lang';

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
}

