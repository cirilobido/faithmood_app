class SettingsState {
  final bool? isPremium;
  final String? appVersion;
  final bool isLoading;
  final bool error;

  SettingsState({
    this.isPremium,
    this.appVersion,
    this.isLoading = false,
    this.error = false,
  });

  SettingsState copyWith({
    bool? isPremium,
    String? appVersion,
    bool? isLoading,
    bool? error,
  }) {
    return SettingsState(
      isPremium: isPremium ?? this.isPremium,
      appVersion: appVersion ?? this.appVersion,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

