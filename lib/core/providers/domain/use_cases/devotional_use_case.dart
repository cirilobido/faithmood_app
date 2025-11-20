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

  Future<Result<Devotional?, Exception>> getDevotionalById(int id, String lang) async {
    try {
      final result = await repository.getDevotionalById(id, lang);
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

  Future<Result<bool, Exception>> saveDevotionalLog(int userId, DevotionalLogRequest request) async {
    try {
      final result = await repository.saveDevotionalLog(userId, request);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<DevotionalLogsResponse?, Exception>> getDevotionalLogs(int userId, Map<String, dynamic>? queryParams) async {
    try {
      final result = await repository.getDevotionalLogs(userId, queryParams);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<DevotionalLog?, Exception>> getDevotionalLogDetail(int userId, int id, String lang) async {
    try {
      final result = await repository.getDevotionalLogDetail(userId, id, lang);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<DevotionalLog?, Exception>> updateDevotionalLog(int userId, int id, DevotionalLogUpdateRequest request) async {
    try {
      final result = await repository.updateDevotionalLog(userId, id, request);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool, Exception>> deleteDevotionalLog(int userId, int id) async {
    try {
      final result = await repository.deleteDevotionalLog(userId, id);
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

