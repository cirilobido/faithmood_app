import 'package:faithmood_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/settings_repository.dart';
import '../data_sources/remote/settings_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    settingsService: ref.watch(settingsServiceProvider),
  );
});

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsService settingsService;

  SettingsRepositoryImpl({
    required this.settingsService,
  });

  @override
  Future<Settings?> getSettings() async {
    try {
      Settings? result = await settingsService.getSettings();
      return result;
    } catch (_) {
      throw Exception('Error getting settings from RIMP!');
    }
  }
}
