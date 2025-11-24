import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../dev_utils/_logger.dart';
import '../../static/_static_constants.dart';

final rewardedAdProvider = NotifierProvider<RewardedAdHelper, void>(() {
  return RewardedAdHelper();
});

class RewardedAdHelper extends Notifier<void> {
  RewardedAd? _rewardedAd;

  final String _adUnitId = Constant.admobRewardedAdUnitId;

  bool get isAdAvailable => _rewardedAd != null;

  @override
  void build() {
    // no state, so nothing to do here
  }

  Future<void> loadAd() async {
    await RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          devLogger('Rewarded ad loaded ✅');
        },
        onAdFailedToLoad: (LoadAdError error) {
          devLogger('Rewarded ad failed to load ❌: $error');
        },
      ),
    );
  }

  void showAd({
    required VoidCallback onAdDismissed,
    required VoidCallback onAdFailed,
    VoidCallback? onUserEarnedReward,
  }) {
    if (_rewardedAd == null) {
      devLogger('Tried to show rewarded ad but none is loaded.');
      onAdFailed();
      return;
    }

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        devLogger('Rewarded ad dismissed.');
        ad.dispose();
        _rewardedAd = null;
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        devLogger('Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        onAdFailed();
      },
    );

    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        devLogger('User earned reward: ${reward.amount} ${reward.type}');
        onUserEarnedReward?.call();
      },
    );
  }
}

