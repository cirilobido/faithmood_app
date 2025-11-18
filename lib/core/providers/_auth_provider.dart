// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';

import '../../dev_utils/_logger.dart';
import '../core_exports.dart';
import 'domain/use_cases/auth_use_case.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref.read(authUseCaseProvider));
});

class AuthProvider extends ChangeNotifier {
  final AuthUseCase _useCase;

  AuthProvider(this._useCase);

  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  User? _user;

  User? get user => _user;

  Plans? _currentPlan;

  get currentPlan => _currentPlan;

  Future<void> registerUser(AuthRequest params) async {
    try {
      final result = await _useCase.registerUser(
        params,
      );
      switch (result) {
        case Success(value: final value):
          {
            _user = value;
          }
        case Failure():
          {
            throw Exception('Error registering user!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> loginUser(AuthRequest params) async {
    try {
      final firebaseMessagingService = FirebaseMessagingService.instance();
      final token = await firebaseMessagingService.getToken();
      final result = await _useCase.loginUser(params.copyWith(fcmToken: token));
      switch (result) {
        case Success(value: final value):
          {
            _user = value;
          }
        case Failure():
          {
            throw Exception('Error logging in user!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> refreshUserInformation() async {
    try {
      final result = await _useCase.refreshUser();
      switch (result) {
        case Success(value: final value):
          {
            _user = value;
          }
        case Failure():
          {
            throw Exception('Error getting user!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> setCurrentPlan(Plans plan) async {
    try {
      _currentPlan = plan;
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _useCase.signOut();
      _user = null;
      _currentPlan = null;
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateUserData(User params) async {
    try {
      final result = await _useCase.updateUserData(params);
      switch (result) {
        case Success(value: final value):
          {
            _user = value;
          }
        case Failure():
          {
            throw Exception('Error updating user!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    try {
      final result = await _useCase.deleteUser(id);
      switch (result) {
        case Success():
          {
            await _useCase.signOut();
            _user = null;
            _currentPlan = null;
          }
        case Failure():
          {
            throw Exception('Error deleting user!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> changePassword(User params) async {
    try {
      final result = await _useCase.changePassword(params);
      switch (result) {
        case Success(value: final value):
          {
            _user = value;
          }
        case Failure():
          {
            throw Exception('Error changing password!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<bool> sendOtp(AuthRequest params) async {
    try {
      final result = await _useCase.sendOtp(params);
      switch (result) {
        case Success(value: final value):
          {
            return value;
          }
        case Failure():
          {
            throw Exception('Error sending otp!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
  }

  Future<bool> verifyOtp(AuthRequest params) async {
    try {
      final result = await _useCase.verifyOtp(params);
      switch (result) {
        case Success(value: final value):
          {
            return value;
          }
        case Failure():
          {
            throw Exception('Error verifying otp!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
  }

  Future<void> syncSubscription(CustomerInfo customerInfo) async {
    try {
      await refreshUserInformation();
      _user = _user?.copyWith(planType: PlanName.PREMIUM);
      // TODO: Implement if is need it in future,
      //  revenue cat webhook is now handling this logic in the server side.
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }
}
