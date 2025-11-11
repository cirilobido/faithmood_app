class WelcomeState {
  bool isLoading;
  bool error;

  WelcomeState({
    this.isLoading = false,
    this.error = false,
  });

  WelcomeState copyWith({
    bool? isLoading,
    bool? error,
  }) {
    return WelcomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}