import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/tag_repository_impl.dart';
import '../repository/tag_repository.dart';

final tagUseCaseProvider = Provider<TagUseCase>(
  (ref) => TagUseCase(ref.watch(tagRepositoryProvider)),
);

class TagUseCase extends FutureUseCase<dynamic, dynamic> {
  final TagRepository repository;

  TagUseCase(this.repository);

  Future<Result<List<Tag>, Exception>> getTags(String lang) async {
    try {
      final result = await repository.getTags(lang);
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

