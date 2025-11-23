abstract class LocalStorageRepository {

  Future<bool> getIsUserLoggedIn();

  Future<bool> getIsFirstTimeOpen();

  Future<void> setFirstTimeOpen(bool isDarkMode);

  Future<String?> getAppLanguage();

  Future<void> setAppLanguage(String language);

  Future<String?> getReminderTime();

  Future<void> setReminderTime(String time);

  Future<void> deleteReminderTime();

  Future<String?> getThemeMode();

  Future<void> setThemeMode(String mode);
}
