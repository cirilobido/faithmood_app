import 'package:faithmood_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/category_repository.dart';
import '../data_sources/remote/category_service.dart';
import '../data_sources/local/category_dao.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    categoryService: ref.watch(categoryServiceProvider),
    categoryDao: ref.watch(categoryDaoProvider),
  );
});

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryService categoryService;
  final CategoryDao categoryDao;

  CategoryRepositoryImpl({
    required this.categoryService,
    required this.categoryDao,
  });

  @override
  Future<List<DevotionalCategory>> getCategories(String lang) async {
    try {
      // Always try to fetch from backend first
      final result = await categoryService.getCategories(lang);
      
      // Save the new categories for future use (cache)
      if (result.isNotEmpty) {
        await categoryDao.saveCategories(result, lang);
      }
      
      return result;
    } catch (apiError) {
      // If API call fails, fall back to cached categories
      final cachedCategories = await categoryDao.getCategories(lang);
      if (cachedCategories != null && cachedCategories.isNotEmpty) {
        return cachedCategories;
      }
      // If no cached categories and API fails, rethrow the error
      throw Exception('Error getting categories from RIMP!');
    }
  }
}

