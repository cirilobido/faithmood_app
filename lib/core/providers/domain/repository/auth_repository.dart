import 'package:selah_app/core/core_exports.dart';

abstract class AuthRepository {
  Future<User> registerUser(AuthRequest params);

  Future<User> loginUser(AuthRequest params);

  Future<String?> refreshToken(String refreshToken);

  Future<String?> getLocalToken();

  Future<User?> refreshUser();

  Future<User?> getCachedUser();

  Future<void> signOut();

  Future<User> updateUserData(User params);

  Future<User> deleteUser(int id);

  Future<User> changePassword(User params);

  Future<bool> sendOtp(AuthRequest params);

  Future<bool> verifyOtp(AuthRequest params);

  Future<User?> syncSubscription(AuthRequest params);
}
