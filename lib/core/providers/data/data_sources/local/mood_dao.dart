import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final moodDaoProvider = Provider<MoodDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return MoodDaoImpl(secureStorage: secureStorage);
});

abstract class MoodDao {
  Future<bool?> saveMoods(List<Mood> moods, String lang);
  Future<List<Mood>?> getMoods(String lang);
  Future<String?> getMoodsDate(String lang);
  Future<bool?> deleteMoods(String lang);
}

class MoodDaoImpl implements MoodDao {
  final SecureStorage secureStorage;

  MoodDaoImpl({required this.secureStorage});

  String _getMoodsKey(String lang) => '${Constant.moodsKey}_$lang';
  String _getMoodsDateKey(String lang) => '${Constant.moodsDateKey}_$lang';

  @override
  Future<List<Mood>?> getMoods(String lang) async {
    final moodsJson = await secureStorage.getValue(
      key: _getMoodsKey(lang),
    );
    if (moodsJson == null) return null;
    try {
      final List<dynamic> jsonList = jsonDecode(moodsJson);
      return jsonList
          .map((item) => Mood.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> saveMoods(List<Mood> moods, String lang) async {
    final moodsJsonEncoded = jsonEncode(
      moods.map((mood) => mood.toJson()).toList(),
    );
    await deleteMoods(lang);
    await secureStorage.saveValue(
      key: _getMoodsKey(lang),
      value: moodsJsonEncoded,
    );
    final now = DateTime.now().toIso8601String();
    await secureStorage.saveValue(
      key: _getMoodsDateKey(lang),
      value: now,
    );
    return true;
  }

  @override
  Future<bool> deleteMoods(String lang) async {
    await secureStorage.deleteValue(key: _getMoodsKey(lang));
    await secureStorage.deleteValue(key: _getMoodsDateKey(lang));
    return true;
  }

  @override
  Future<String?> getMoodsDate(String lang) async {
    return await secureStorage.getValue(key: _getMoodsDateKey(lang));
  }
}

