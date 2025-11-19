import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final verseDaoProvider = Provider<VerseDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return VerseDaoImpl(secureStorage: secureStorage);
});

abstract class VerseDao {
  Future<bool?> saveDailyVerse(Verse params, String lang);
  Future<Verse?> getDailyVerse(String lang);
  Future<String?> getDailyVerseDate();
  Future<bool?> deleteDailyVerse(String lang);
  Future<String?> getDailyVerseDateForLang(String lang);
}

class VerseDaoImpl implements VerseDao {
  final SecureStorage secureStorage;

  VerseDaoImpl({required this.secureStorage});

  String _getVerseKey(String lang) => '${Constant.dailyVerseKey}_$lang';
  String _getDateKey(String lang) => '${Constant.dailyVerseDateKey}_$lang';

  @override
  Future<Verse?> getDailyVerse(String lang) async {
    final verseJson = await secureStorage.getValue(
      key: _getVerseKey(lang),
    );
    if (verseJson == null) return null;
    try {
      return Verse.fromJson(jsonDecode(verseJson));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> saveDailyVerse(Verse params, String lang) async {
    final verseJsonEncoded = jsonEncode(params.toJson());
    await deleteDailyVerse(lang);
    await secureStorage.saveValue(
      key: _getVerseKey(lang),
      value: verseJsonEncoded,
    );
    // Save the date when verse was stored (YYYY-MM-DD format)
    final today = DateTime.now();
    final dateString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await secureStorage.saveValue(
      key: _getDateKey(lang),
      value: dateString,
    );
    return true;
  }

  @override
  Future<bool> deleteDailyVerse(String lang) async {
    await secureStorage.deleteValue(key: _getVerseKey(lang));
    await secureStorage.deleteValue(key: _getDateKey(lang));
    return true;
  }

  @override
  Future<String?> getDailyVerseDate() async {
    // This method is not used, but kept for interface consistency
    // The date check is done in the repository with getDailyVerseDateForLang
    return null;
  }

  @override
  Future<String?> getDailyVerseDateForLang(String lang) async {
    final dateString = await secureStorage.getValue(
      key: _getDateKey(lang),
    );
    return dateString;
  }
}
