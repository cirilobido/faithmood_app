class ReminderState {
  final String? time;
  final bool isLoading;
  final bool error;

  ReminderState({
    this.time,
    this.isLoading = false,
    this.error = false,
  });

  ReminderState copyWith({
    String? time,
    bool? isLoading,
    bool? error,
  }) {
    return ReminderState(
      time: time ?? this.time,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

