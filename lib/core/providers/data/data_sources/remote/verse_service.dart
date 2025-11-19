import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final verseServiceProvider = Provider<VerseService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return VerseServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class VerseService {
  Future<Verse?> getDailyVerse(String lang);
}

class VerseServiceImpl implements VerseService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  VerseServiceImpl({required this.httpClient, required this.requestProcessor});

  @override
  Future<Verse?> getDailyVerse(String lang) async {
    try {
      final request =
          await requestProcessor.process(
                request: httpClient.get(Endpoints.dailyVerse(lang)),
                jsonMapper: (data) {
                  final response = VerseResponse.fromJson(data);
                  return response.verse;
                },
              )
              as Verse?;
      return request;
    } catch (e) {
      throw Exception();
    }
  }
}
