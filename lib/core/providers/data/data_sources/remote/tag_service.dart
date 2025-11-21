import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final tagServiceProvider = Provider<TagService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return TagServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class TagService {
  Future<List<Tag>> getTags(String lang);
}

class TagServiceImpl implements TagService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  TagServiceImpl({required this.httpClient, required this.requestProcessor});

  @override
  Future<List<Tag>> getTags(String lang) async {
    try {
      final request = await requestProcessor.process(
        request: httpClient.get(Endpoints.getTags(lang)),
        jsonMapper: (data) {
          final response = TagsResponse.fromJson(data as Map<String, dynamic>);
          return response.tags ?? [];
        },
      ) as List<Tag>;
      return request;
    } catch (e) {
      throw Exception();
    }
  }
}

