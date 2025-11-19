import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return CategoryDaoImpl(secureStorage: secureStorage);
});

abstract class CategoryDao {
  Future<bool?> saveCategories(List<DevotionalCategory> categories, String lang);
  Future<List<DevotionalCategory>?> getCategories(String lang);
  Future<bool?> deleteCategories(String lang);
  Future<String?> getCategoriesDate(String lang);
}

class CategoryDaoImpl implements CategoryDao {
  final SecureStorage secureStorage;

  CategoryDaoImpl({required this.secureStorage});

  String _getCategoriesKey(String lang) => '${Constant.categoriesKey}_$lang';
  String _getCategoriesDateKey(String lang) => '${Constant.categoriesDateKey}_$lang';

  @override
  Future<List<DevotionalCategory>?> getCategories(String lang) async {
    final categoriesJson = await secureStorage.getValue(
      key: _getCategoriesKey(lang),
    );
    if (categoriesJson == null) return null;
    try {
      final List<dynamic> jsonList = jsonDecode(categoriesJson);
      return jsonList
          .map((item) => DevotionalCategory.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> saveCategories(List<DevotionalCategory> categories, String lang) async {
    final categoriesJsonEncoded = jsonEncode(
      categories.map((cat) => cat.toJson()).toList(),
    );
    await deleteCategories(lang);
    await secureStorage.saveValue(
      key: _getCategoriesKey(lang),
      value: categoriesJsonEncoded,
    );
    final now = DateTime.now().toIso8601String();
    await secureStorage.saveValue(
      key: _getCategoriesDateKey(lang),
      value: now,
    );
    return true;
  }

  @override
  Future<bool> deleteCategories(String lang) async {
    await secureStorage.deleteValue(key: _getCategoriesKey(lang));
    await secureStorage.deleteValue(key: _getCategoriesDateKey(lang));
    return true;
  }

  @override
  Future<String?> getCategoriesDate(String lang) async {
    return await secureStorage.getValue(key: _getCategoriesDateKey(lang));
  }
}

