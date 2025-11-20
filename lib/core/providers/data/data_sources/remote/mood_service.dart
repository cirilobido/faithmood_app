import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final moodServiceProvider = Provider<MoodService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return MoodServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class MoodService {
  Future<MoodsResponse?> getMoods(String lang);
  Future<MoodSessionResponse?> createMoodSession(int userId, MoodSessionRequest request);
}

class MoodServiceImpl implements MoodService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  MoodServiceImpl({
    required this.httpClient,
    required this.requestProcessor,
  });

  @override
  Future<MoodsResponse?> getMoods(String lang) async {
    try {
      final request = await requestProcessor.process(
        request: httpClient.get(Endpoints.getMoods(lang)),
        jsonMapper: (data) {
          return MoodsResponse.fromJson(data as Map<String, dynamic>);
        },
      ) as MoodsResponse?;
      return request;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<MoodSessionResponse?> createMoodSession(int userId, MoodSessionRequest request) async {
    try {
      final response = await requestProcessor.process(
        request: httpClient.post(
          Endpoints.createMoodSession(userId),
          data: request.toJson(),
        ),
        jsonMapper: (data) {
          return MoodSessionResponse.fromJson(data as Map<String, dynamic>);
        },
      ) as MoodSessionResponse?;
      return response;
    } catch (e) {
      throw Exception();
    }
  }
}

