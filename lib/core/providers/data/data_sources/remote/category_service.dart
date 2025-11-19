import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return CategoryServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class CategoryService {
  Future<List<DevotionalCategory>> getCategories(String lang);
}

class CategoryServiceImpl implements CategoryService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  CategoryServiceImpl({required this.httpClient, required this.requestProcessor});

  @override
  Future<List<DevotionalCategory>> getCategories(String lang) async {
    try {
      final request = await requestProcessor.process(
        request: httpClient.get(Endpoints.getCategories(lang)),
        jsonMapper: (data) {
          final response = CategoriesResponse.fromJson(data as Map<String, dynamic>);
          return response.categories ?? [];
        },
      ) as List<DevotionalCategory>;
      return request;
    } catch (e) {
      throw Exception();
    }
  }
}

