import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/category_repository_impl.dart';
import '../repository/category_repository.dart';

final categoryUseCaseProvider = Provider<CategoryUseCase>(
  (ref) => CategoryUseCase(ref.watch(categoryRepositoryProvider)),
);

class CategoryUseCase extends FutureUseCase<dynamic, dynamic> {
  final CategoryRepository repository;

  CategoryUseCase(this.repository);

  Future<Result<List<DevotionalCategory>, Exception>> getCategories(String lang) async {
    try {
      final result = await repository.getCategories(lang);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}

