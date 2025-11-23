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
  Future<DevotionalsResponse?> getAllDevotionals(
    String lang, {
    int? page,
    int? limit,
    int? categoryId,
    String? tags,
  });
  Future<bool> saveDevotionalLog(int userId, DevotionalLogRequest request);
  Future<DevotionalLogsResponse?> getDevotionalLogs(int userId, Map<String, dynamic>? queryParams);
  Future<DevotionalLog?> getDevotionalLogDetail(int userId, int id, String lang);
  Future<DevotionalLog?> updateDevotionalLog(int userId, int id, DevotionalLogUpdateRequest request);
  Future<bool> deleteDevotionalLog(int userId, int id);
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
  Future<DevotionalsResponse?> getAllDevotionals(
    String lang, {
    int? page,
    int? limit,
    int? categoryId,
    String? tags,
  }) async {
    try {
      final request =
          await requestProcessor.process(
                request: httpClient.get(
                  Endpoints.getAllDevotionals(
                    lang,
                    page: page,
                    limit: limit,
                    categoryId: categoryId,
                    tags: tags,
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

  @override
  Future<DevotionalLogsResponse?> getDevotionalLogs(int userId, Map<String, dynamic>? queryParams) async {
    try {
      final response = await requestProcessor.process(
        request: httpClient.get(Endpoints.getDevotionalLogs(userId, queryParams: queryParams)),
        jsonMapper: (data) {
          return DevotionalLogsResponse.fromJson(data as Map<String, dynamic>);
        },
      ) as DevotionalLogsResponse?;
      return response;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<DevotionalLog?> getDevotionalLogDetail(int userId, int id, String lang) async {
    try {
      final response = await requestProcessor.process(
        request: httpClient.get(Endpoints.getDevotionalLogDetail(userId, id, lang)),
        jsonMapper: (data) {
          return DevotionalLog.fromJson(data as Map<String, dynamic>);
        },
      ) as DevotionalLog?;
      return response;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<DevotionalLog?> updateDevotionalLog(int userId, int id, DevotionalLogUpdateRequest request) async {
    try {
      final response = await requestProcessor.process(
        request: httpClient.put(
          Endpoints.updateDevotionalLog(userId, id),
          data: request.toJson(),
        ),
        jsonMapper: (data) {
          return DevotionalLog.fromJson(data as Map<String, dynamic>);
        },
      ) as DevotionalLog?;
      return response;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<bool> deleteDevotionalLog(int userId, int id) async {
    try {
      await requestProcessor.process(
        request: httpClient.delete(Endpoints.deleteDevotionalLog(userId, id)),
        jsonMapper: (data) => true,
      );
      return true;
    } catch (e) {
      throw Exception();
    }
  }
}
