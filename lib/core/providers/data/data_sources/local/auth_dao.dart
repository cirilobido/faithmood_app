import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core_exports.dart';

final authDaoProvider = Provider<AuthDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return AuthDaoImpl(secureStorage: secureStorage);
});

abstract class AuthDao {
  // USER STORAGE
  Future<bool?> saveCurrentUser(User params);

  Future<User?> getCurrentUser();

  Future<bool?> deleteCurrentUser();

  Future<bool?> saveCurrentUserToken(String params);

  Future<String?> getCurrentUserToken();

  Future<bool?> deleteCurrentUserToken();
}

class AuthDaoImpl extends AuthDao {
  final SecureStorage secureStorage;

  AuthDaoImpl({required this.secureStorage});

  @override
  Future<User?> getCurrentUser() async {
    final userJson = await secureStorage.getValue(
      key: Constant.current_session_user,
    );
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  @override
  Future<bool> saveCurrentUser(User params) async {
    final userJsonEncoded = jsonEncode(params.toJson());
    await deleteCurrentUser();
    await secureStorage.saveValue(
      key: Constant.current_session_user,
      value: userJsonEncoded,
    );
    return true;
  }

  @override
  Future<bool> deleteCurrentUser() async {
    await secureStorage.deleteValue(key: Constant.current_session_user);
    return true;
  }

  @override
  Future<String?> getCurrentUserToken() async {
    final data = await secureStorage.getValue(
      key: Constant.current_session_user_token,
    );
    return data;
  }

  @override
  Future<bool> saveCurrentUserToken(String params) async {
    await deleteCurrentUserToken();
    await secureStorage.saveValue(
      key: Constant.current_session_user_token,
      value: params,
    );
    return true;
  }

  @override
  Future<bool> deleteCurrentUserToken() async {
    await secureStorage.deleteValue(key: Constant.current_session_user_token);
    return true;
  }
}
