import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../dev_utils/_logger.dart';
import '../../static/_static_constants.dart';

final interstitialAdProvider = NotifierProvider<InterstitialAdHelper, void>(() {
  return InterstitialAdHelper();
});

class InterstitialAdHelper extends Notifier<void> {
  InterstitialAd? _interstitialAd;

  final String _adUnitId = Constant.admobInterstitialAdUnitId;

  bool get isAdAvailable => _interstitialAd != null;

  @override
  void build() {
    // no state, so nothing to do here
  }

  Future<void> loadAd() async {
    await InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          devLogger('Ad loaded ✅');
        },
        onAdFailedToLoad: (LoadAdError error) {
          devLogger('Ad failed to load ❌: $error');
        },
      ),
    );
  }

  void showAd({
    required VoidCallback onAdDismissed,
    required VoidCallback onAdFailed,
  }) {
    if (_interstitialAd == null) {
      devLogger('Tried to show ad but none is loaded.');
      onAdFailed();
      return;
    }

    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        devLogger('Ad dismissed.');
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        devLogger('Ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        onAdFailed();
      },
    );

    _interstitialAd?.show();
  }
}

