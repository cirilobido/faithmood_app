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
  Future<List<DevotionalCategory>> getCategories(String lang) async {
    try {
      final cachedDate = await categoryDao.getCategoriesDate(lang);
      
      if (_isCacheValid(cachedDate)) {
        final cachedCategories = await categoryDao.getCategories(lang);
        if (cachedCategories != null && cachedCategories.isNotEmpty) {
          return cachedCategories;
        }
      }
      
      final result = await categoryService.getCategories(lang);
      
      if (result.isNotEmpty) {
        await categoryDao.saveCategories(result, lang);
      }
      
      return result;
    } catch (apiError) {
      final cachedCategories = await categoryDao.getCategories(lang);
      if (cachedCategories != null && cachedCategories.isNotEmpty) {
        return cachedCategories;
      }
      throw Exception('Error getting categories from RIMP!');
    }
  }
}

