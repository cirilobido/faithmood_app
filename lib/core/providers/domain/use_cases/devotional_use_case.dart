import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/devotional_repository_impl.dart';
import '../repository/devotional_repository.dart';

final devotionalUseCaseProvider = Provider<DevotionalUseCase>(
  (ref) => DevotionalUseCase(ref.watch(devotionalRepositoryProvider)),
);

class DevotionalUseCase extends FutureUseCase<dynamic, dynamic> {
  final DevotionalRepository repository;

  DevotionalUseCase(this.repository);

  Future<Result<Devotional?, Exception>> getDailyDevotional(String lang) async {
    try {
      final result = await repository.getDailyDevotional(lang);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<DevotionalsResponse, Exception>> getDevotionalsByCategory(int categoryId, String lang, {int? page, int? limit}) async {
    try {
      final result = await repository.getDevotionalsByCategory(categoryId, lang, page: page, limit: limit);
      return Success(result ?? DevotionalsResponse(results: []));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<DevotionalsResponse, Exception>> getDevotionalsByTag(int tagId, String lang, {int? page, int? limit}) async {
    try {
      final result = await repository.getDevotionalsByTag(tagId, lang, page: page, limit: limit);
      return Success(result ?? DevotionalsResponse(results: []));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}

