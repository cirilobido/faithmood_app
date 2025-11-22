import '../../../core/core_exports.dart';

class SecurityState {
  final User? user;
  final bool? isPremium;
  final bool isLoading;
  final bool error;

  SecurityState({
    this.user,
    this.isPremium,
    this.isLoading = false,
    this.error = false,
  });

  SecurityState copyWith({
    User? user,
    bool? isPremium,
    bool? isLoading,
    bool? error,
  }) {
    return SecurityState(
      user: user ?? this.user,
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

