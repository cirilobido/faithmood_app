import 'package:faithmood_app/core/core_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/local/auth_dao.dart';
import '../data_sources/remote/auth_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authService: ref.watch(authServiceProvider),
    authDao: ref.watch(authDaoProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final AuthDao authDao;

  AuthRepositoryImpl({required this.authService, required this.authDao});

  @override
  Future<User> registerUser(AuthRequest params) async {
    try {
      UserResponse? result = await authService.registerUser(params);
      if (result?.user != null) {
        await authDao.saveCurrentUser(result!.user!);
      }
      if (result?.token != null) {
        await authDao.saveCurrentUserToken(result!.token!);
      }
      if (result?.user == null) {
        throw Exception();
      }
      return result!.user!;
    } catch (_) {
      throw Exception('Error registering user from RIMP!');
    }
  }

  @override
  Future<User> loginUser(AuthRequest params) async {
    try {
      UserResponse? result = await authService.loginUser(params);
      if (result?.user != null) {
        await authDao.saveCurrentUser(result!.user!);
      }
      if (result?.token != null) {
        await authDao.saveCurrentUserToken(result!.token!);
      }
      if (result?.user == null) {
        throw Exception();
      }
      return result!.user!;
    } catch (_) {
      throw Exception('Error logging in user from RIMP!');
    }
  }

  @override
  Future<User?> refreshUser() async {
    try {
      final currentUser = await authDao.getCurrentUser();
      if (currentUser != null && currentUser.id != null) {
        final result = await authService.getUser(currentUser.id!);
        if (result?.user != null) {
          await authDao.saveCurrentUser(result!.user!);
          return result.user!;
        }
      }
      return currentUser;
    } on ConnectionError {
      final currentUser = await authDao.getCurrentUser();
      return currentUser;
    } catch (_) {
      throw Exception('Error refreshing user!');
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      return await authDao.getCurrentUser();
    } catch (_) {
      throw Exception('Error getting cached user!');
    }
  }

  @override
  Future<String?> refreshToken(String token) async {
    try {
      final result = await authService.refreshToken(token);
      if (result?.token != null) {
        await authDao.saveCurrentUserToken(result!.token!);
      }
      return result?.token;
    } catch (_) {
      throw Exception('Error refreshing token from RIMP!');
    }
  }

  @override
  Future<String?> getLocalToken() async {
    try {
      String? result = await authDao.getCurrentUserToken();
      return result;
    } catch (_) {
      throw Exception('Error getting local token from RIMP!');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authDao.deleteCurrentUser();
      await authDao.deleteCurrentUserToken();
    } catch (_) {
      throw Exception('Error signing out user from RIMP!');
    }
  }

  @override
  Future<User> updateUserData(User params) async {
    try {
      UserResponse? result = await authService.updateUserData(params);
      if (result?.user != null) {
        await authDao.saveCurrentUser(result!.user!);
      }
      if (result?.user == null) {
        throw Exception();
      }
      return result!.user!;
    } catch (_) {
      throw Exception('Error updating user from RIMP!');
    }
  }

  @override
  Future<User> deleteUser(int id) async {
    try {
      UserResponse? result = await authService.deleteUser(id);
      if (result?.user != null) {
        throw Exception();
      }
      return result!.user!;
    } catch (_) {
      throw Exception('Error deleting user from RIMP!');
    }
  }

  @override
  Future<User> changePassword(User params) async {
    try {
      UserResponse? result = await authService.changePassword(params);
      if (result?.user == null) {
        throw Exception();
      }
      return result!.user!;
    } catch (_) {
      throw Exception('Error changing password from RIMP!');
    }
  }

  @override
  Future<bool> sendOtp(AuthRequest params) async {
    try {
      final result = await authService.sendOtp(params);
      return result;
    } catch (_) {
      throw Exception('Error sending otp from RIMP!');
    }
  }

  @override
  Future<bool> verifyOtp(AuthRequest params) async {
    try {
      final result = await authService.verifyOtp(params);
      return result;
    } catch (_) {
      throw Exception('Error verifying otp from RIMP!');
    }
  }

  @override
  Future<User?> syncSubscription(AuthRequest params) async {
    try {
      final result = await authService.syncSubscription(params);
      if (result?.user != null) {
        await authDao.saveCurrentUser(result!.user!);
      }
      return result?.user;
    } catch (_) {
      throw Exception('Error syncing subscription from RIMP!');
    }
  }
}
