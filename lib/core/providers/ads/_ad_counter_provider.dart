import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_ad_counter_state.dart';

final adCounterProvider = NotifierProvider<AdCounter, AdCounterState>(() {
  return AdCounter();
});

class AdCounter extends Notifier<AdCounterState> {
  @override
  AdCounterState build() {
    return const AdCounterState();
  }

  void incrementAction() {
    state = state.copyWith(actionCount: state.actionCount + 1);
  }

  bool shouldShowAd(int fullAdsInterval) {
    if (state.actionCount == 0) return false;
    if (state.actionCount == 1) return true;
    return (state.actionCount - 1) % fullAdsInterval == 0;
  }

  bool shouldShowRewardedAd() {
    return state.adShowCount > 0 && state.adShowCount % 3 == 0;
  }

  void resetAfterAd() {
    state = state.copyWith(
      actionCount: 0,
      adShowCount: state.adShowCount + 1,
    );
  }

  void resetInterstitial() {
    state = state.copyWith(actionCount: 0);
  }
}

