import 'package:faithmood_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/settings_repository.dart';
import '../data_sources/remote/settings_service.dart';
import '../data_sources/local/settings_dao.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    settingsService: ref.watch(settingsServiceProvider),
    settingsDao: ref.watch(settingsDaoProvider),
  );
});

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsService settingsService;
  final SettingsDao settingsDao;

  SettingsRepositoryImpl({
    required this.settingsService,
    required this.settingsDao,
  });

  @override
  Future<Settings?> getSettings() async {
    try {
      // Always try to fetch from backend first
      final result = await settingsService.getSettings();
      
      // Save the new settings for future use (cache)
      if (result != null) {
        await settingsDao.saveSettings(result);
      }
      
      return result;
    } catch (apiError) {
      // If API call fails, fall back to cached settings
      final cachedSettings = await settingsDao.getSettings();
      if (cachedSettings != null) {
        return cachedSettings;
      }
      // If no cached settings and API fails, rethrow the error
      throw Exception('Error getting settings from RIMP!');
    }
  }
}
