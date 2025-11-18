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
}

class DevotionalServiceImpl implements DevotionalService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  DevotionalServiceImpl({required this.httpClient, required this.requestProcessor});

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
}

