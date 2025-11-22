import '../../../core/core_exports.dart';

class MyInformationState {
  final User? user;
  final bool? isPremium;
  final bool isLoading;
  final bool error;

  MyInformationState({
    this.user,
    this.isPremium,
    this.isLoading = false,
    this.error = false,
  });

  MyInformationState copyWith({
    User? user,
    bool? isPremium,
    bool? isLoading,
    bool? error,
  }) {
    return MyInformationState(
      user: user ?? this.user,
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

