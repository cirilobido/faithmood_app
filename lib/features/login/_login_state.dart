class LoginState {
  bool isLoading;
  bool error;

  LoginState({
    this.isLoading = false,
    this.error = false,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}