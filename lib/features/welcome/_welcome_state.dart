class WelcomeState {
  int currentPage;
  double progress;
  bool isLoading;
  bool error;

  WelcomeState({
    this.currentPage = 0,
    this.progress = 0,
    this.isLoading = false,
    this.error = false,
  });

  WelcomeState copyWith({
    int? currentPage,
    double? progress,
    bool? isLoading,
    bool? error,
  }) {
    return WelcomeState(
      currentPage: currentPage ?? this.currentPage,
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
