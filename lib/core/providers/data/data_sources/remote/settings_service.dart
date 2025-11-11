import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return SettingsServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class SettingsService {
  Future<Settings?> getSettings();
}

class SettingsServiceImpl implements SettingsService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  SettingsServiceImpl({
    required this.httpClient,
    required this.requestProcessor,
  });

  @override
  Future<Settings?> getSettings() async {
    // TODO: Fix when backend endpoint is ready
    return Settings();
    try {
      final request = await requestProcessor.process(
        request: httpClient.get(Endpoints.settings),
        jsonMapper: (data) {
          final response = SettingsResponse.fromJson(
            data as Map<String, dynamic>,
          );
          if (response.settings == null) {
            throw Exception();
          }
          return response.settings;
        },
      ) as Settings?;
      return request;
    } catch (e) {
      throw Exception();
    }
  }
}
