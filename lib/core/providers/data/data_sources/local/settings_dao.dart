import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return SettingsDaoImpl(secureStorage: secureStorage);
});

abstract class SettingsDao {
  Future<bool?> saveSettings(Settings params);
  Future<Settings?> getSettings();
  Future<bool?> deleteSettings();
}

class SettingsDaoImpl implements SettingsDao {
  final SecureStorage secureStorage;

  SettingsDaoImpl({required this.secureStorage});

  String _getSettingsKey() => Constant.settingsKey;

  @override
  Future<Settings?> getSettings() async {
    final settingsJson = await secureStorage.getValue(
      key: _getSettingsKey(),
    );
    if (settingsJson == null) return null;
    try {
      return Settings.fromJson(jsonDecode(settingsJson));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> saveSettings(Settings params) async {
    final settingsJsonEncoded = jsonEncode(params.toJson());
    await deleteSettings();
    await secureStorage.saveValue(
      key: _getSettingsKey(),
      value: settingsJsonEncoded,
    );
    return true;
  }

  @override
  Future<bool> deleteSettings() async {
    await secureStorage.deleteValue(key: _getSettingsKey());
    return true;
  }
}

