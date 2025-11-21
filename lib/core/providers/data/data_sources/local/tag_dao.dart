import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final tagDaoProvider = Provider<TagDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return TagDaoImpl(secureStorage: secureStorage);
});

abstract class TagDao {
  Future<bool?> saveTags(List<Tag> tags, String lang);
  Future<List<Tag>?> getTags(String lang);
  Future<bool?> deleteTags(String lang);
}

class TagDaoImpl implements TagDao {
  final SecureStorage secureStorage;

  TagDaoImpl({required this.secureStorage});

  String _getTagsKey(String lang) => '${Constant.tagsKey}_$lang';

  @override
  Future<List<Tag>?> getTags(String lang) async {
    final tagsJson = await secureStorage.getValue(
      key: _getTagsKey(lang),
    );
    if (tagsJson == null) return null;
    try {
      final List<dynamic> jsonList = jsonDecode(tagsJson);
      return jsonList
          .map((item) => Tag.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> saveTags(List<Tag> tags, String lang) async {
    final tagsJsonEncoded = jsonEncode(
      tags.map((tag) => tag.toJson()).toList(),
    );
    await deleteTags(lang);
    await secureStorage.saveValue(
      key: _getTagsKey(lang),
      value: tagsJsonEncoded,
    );
    return true;
  }

  @override
  Future<bool> deleteTags(String lang) async {
    await secureStorage.deleteValue(key: _getTagsKey(lang));
    return true;
  }
}

