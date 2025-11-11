class SignUpState {
  bool isLoading;
  bool error;

  SignUpState({
    this.isLoading = false,
    this.error = false,
  });

  SignUpState copyWith({
    bool? isLoading,
    bool? error,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}