import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

final _flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ),
);

final secureStorageServiceProvider = Provider<SecureStorage>((ref) {
  final secureStorage = ref.watch(_flutterSecureStorageProvider);
  return SecureStorageService(secureStorage);
});

class SecureStorageService implements SecureStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageService(this.secureStorage);

  @override
  Future<String?> getValue({required String key}) async {
    try {
      return secureStorage.read(key: key);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveValue({required String key, required String value}) async {
    try {
      await secureStorage.write(key: key, value: value);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteValue({required String key}) async {
    try {
      await secureStorage.delete(key: key);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllValues() async {
    try {
      await secureStorage.deleteAll();
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<bool> existValue({required String key}) async {
    try {
      return secureStorage.containsKey(key: key);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
