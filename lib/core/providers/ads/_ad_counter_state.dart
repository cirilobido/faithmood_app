class AdCounterState {
  final int actionCount;
  final int adShowCount;

  const AdCounterState({
    this.actionCount = 0,
    this.adShowCount = 0,
  });

  AdCounterState copyWith({
    int? actionCount,
    int? adShowCount,
  }) {
    return AdCounterState(
      actionCount: actionCount ?? this.actionCount,
      adShowCount: adShowCount ?? this.adShowCount,
    );
  }
}

