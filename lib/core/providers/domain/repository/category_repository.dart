import 'package:faithmood_app/core/core_exports.dart';

abstract class CategoryRepository {
  Future<List<DevotionalCategory>> getCategories(String lang);
}

