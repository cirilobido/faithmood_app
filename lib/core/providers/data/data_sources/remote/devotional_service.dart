import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final devotionalServiceProvider = Provider<DevotionalService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return DevotionalServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class DevotionalService {
  Future<Devotional?> getDailyDevotional(String lang);
  Future<Devotional?> getDevotionalById(int id, String lang);
  Future<DevotionalsResponse?> getDevotionalsByCategory(
    int categoryId,
    String lang, {
    int? page,
    int? limit,
  });
  Future<DevotionalsResponse?> getDevotionalsByTag(
    int tagId,
    String lang, {
    int? page,
    int? limit,
  });
  Future<bool> saveDevotionalLog(int userId, DevotionalLogRequest request);
}

class DevotionalServiceImpl implements DevotionalService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  DevotionalServiceImpl({
    required this.httpClient,
    required this.requestProcessor,
  });

  @override
  Future<Devotional?> getDailyDevotional(String lang) async {
    try {
      final request =
          await requestProcessor.process(
                request: httpClient.get(Endpoints.dailyDevotional(lang)),
                jsonMapper: (data) {
                  return Devotional.fromJson(data as Map<String, dynamic>);
                },
              )
              as Devotional?;
      return request;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Devotional?> getDevotionalById(int id, String lang) async {
    try {
      final request =
          await requestProcessor.process(
                request: httpClient.get(Endpoints.getDevotionalById(id, lang)),
                jsonMapper: (data) {
                  final response = data as Map<String, dynamic>;
                  if (response.containsKey('devotional')) {
                    return Devotional.fromJson(response['devotional'] as Map<String, dynamic>);
                  }
                  return Devotional.fromJson(response);
                },
              )
              as Devotional?;
      return request;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<DevotionalsResponse?> getDevotionalsByCategory(
    int categoryId,
    String lang, {
    int? page,
    int? limit,
  }) async {
    try {
      final request =
          await requestProcessor.process(
                request: httpClient.get(
                  Endpoints.devotionalsByCategory(
                    categoryId,
                    lang,
                    page: page,
                    limit: limit,
                  ),
                ),
                jsonMapper: (data) {
                  return DevotionalsResponse.fromJson(
                    data as Map<String, dynamic>,
                  );
                },
              )
              as DevotionalsResponse?;
      return request;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<DevotionalsResponse?> getDevotionalsByTag(
    int tagId,
    String lang, {
    int? page,
    int? limit,
  }) async {
    try {
      final request =
          await requestProcessor.process(
                request: httpClient.get(
                  Endpoints.devotionalsByTag(
                    tagId,
                    lang,
                    page: page,
                    limit: limit,
                  ),
                ),
                jsonMapper: (data) {
                  return DevotionalsResponse.fromJson(
                    data as Map<String, dynamic>,
                  );
                },
              )
              as DevotionalsResponse?;
      return request;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<bool> saveDevotionalLog(int userId, DevotionalLogRequest request) async {
    try {
      final result = await requestProcessor.process(
        request: httpClient.post(
          Endpoints.saveDevotionalLog(userId),
          data: request.toJson(),
        ),
        jsonMapper: (data) => true,
      );
      return result == true;
    } catch (e) {
      throw Exception();
    }
  }
}
