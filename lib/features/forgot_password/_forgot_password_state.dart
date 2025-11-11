class ForgotPasswordState {
  bool isLoading;
  bool error;

  ForgotPasswordState({
    this.isLoading = false,
    this.error = false,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? error,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}