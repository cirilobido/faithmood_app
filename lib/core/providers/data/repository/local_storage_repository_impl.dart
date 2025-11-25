import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../core_exports.dart';
import '../../domain/repository/local_storage_repository.dart';
import '../data_sources/local/auth_dao.dart';

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return LocalStorageRepositoryImpl(
    preferences: ref.watch(secureStorageServiceProvider),
    authDao: ref.watch(authDaoProvider),
  );
});

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  final SecureStorage preferences;
  final AuthDao authDao;

  LocalStorageRepositoryImpl({
    required this.preferences,
    required this.authDao,
  });

  @override
  Future<bool> getIsUserLoggedIn() async {
    String? result = await authDao.getCurrentUserToken();
    if (result == null) return false;
    bool isExpired = JwtDecoder.isExpired(result);
    return !isExpired;
  }

  @override
  Future<bool> getIsFirstTimeOpen() async {
    final isFirstTimeOpen = await preferences.getValue(
      key: Constant.isFirstTimeOpenKey,
    );
    return isFirstTimeOpen == null || isFirstTimeOpen != 'false';
  }

  @override
  Future<String?> getAppLanguage() async {
    final result = await preferences.getValue(key: Constant.appLanguageKey);
    return result;
  }

  @override
  Future<void> setAppLanguage(String language) async {
    await preferences.saveValue(key: Constant.appLanguageKey, value: language);
  }

  @override
  Future<void> setFirstTimeOpen(bool isDarkMode) async {
    await preferences.saveValue(
      key: Constant.isFirstTimeOpenKey,
      value: isDarkMode.toString(),
    );
  }

  @override
  Future<String?> getReminderTime() async {
    final result = await preferences.getValue(key: Constant.reminderTimeKey);
    return result;
  }

  @override
  Future<void> setReminderTime(String time) async {
    await preferences.saveValue(key: Constant.reminderTimeKey, value: time);
  }

  @override
  Future<void> deleteReminderTime() async {
    await preferences.deleteValue(key: Constant.reminderTimeKey);
    await preferences.deleteValue(key: Constant.dailyNotificationHourKey);
    await preferences.deleteValue(key: Constant.dailyNotificationMinuteKey);
  }

  @override
  Future<String?> getThemeMode() async {
    final result = await preferences.getValue(key: Constant.themeModeKey);
    return result;
  }

  @override
  Future<void> setThemeMode(String mode) async {
    await preferences.saveValue(key: Constant.themeModeKey, value: mode);
  }

  @override
  Future<bool> getHapticFeedbackEnabled() async {
    final result = await preferences.getValue(key: Constant.hapticFeedbackEnabledKey);
    if (result == null) return true;
    return result == 'true';
  }

  @override
  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    await preferences.saveValue(
      key: Constant.hapticFeedbackEnabledKey,
      value: enabled.toString(),
    );
  }
}
