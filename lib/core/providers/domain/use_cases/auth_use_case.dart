import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../repository/auth_repository.dart';

final authUseCaseProvider = Provider<AuthUseCase>(
      (ref) => AuthUseCase(ref.watch(authRepositoryProvider)),
);

class AuthUseCase extends FutureUseCase<dynamic, dynamic> {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<Result<User, Exception>> registerUser(AuthRequest params) async {
    try {
      final result = await repository.registerUser(params);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<User, Exception>> loginUser(AuthRequest params) async {
    try {
      final result = await repository.loginUser(params);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getLocalToken() async {
    try {
      final result = await repository.getLocalToken();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<User?, Exception>> refreshUser() async {
    try {
      final result = await repository.refreshUser();
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<User?, Exception>> getCachedUser() async {
    try {
      final result = await repository.getCachedUser();
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await repository.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<User, Exception>> updateUserData(User params) async {
    try {
      final result = await repository.updateUserData(params);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<User, Exception>> deleteUser(int id) async {
    try {
      final result = await repository.deleteUser(id);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<User, Exception>> changePassword(User params) async {
    try {
      final result = await repository.changePassword(params);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<bool, Exception>> sendOtp(AuthRequest params) async {
    try {
      final result = await repository.sendOtp(params);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<bool, Exception>> verifyOtp(AuthRequest params) async {
    try {
      final result = await repository.verifyOtp(params);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<User?, Exception>> syncSubscription(AuthRequest params) async {
    try {
      final result = await repository.syncSubscription(params);
      return Success(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}
