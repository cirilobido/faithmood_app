import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dev_utils/_logger.dart';
import '../../core_exports.dart';

class AdHelper {
  static bool _shouldShowAds(WidgetRef ref) {
    final auth = ref.read(authProvider);
    final settings = ref.read(settingsProvider);
    
    final isPremium = auth.user?.planType != PlanName.PREMIUM;
    final showVideoAds = settings.settings?.showVideoAds ?? false;
    
    return !isPremium && showVideoAds;
  }

  static Future<void> performActionWithAd(
    WidgetRef ref,
    Future<void> Function() action, {
    bool forceShow = false,
  }) async {
    if (!forceShow && !_shouldShowAds(ref)) {
      devLogger('Ads not shown - user is premium or showVideoAds is off.');
      await action();
      return;
    }

    final settings = ref.read(settingsProvider);
    final fullAdsInterval = settings.settings?.fullAdsInterval ?? 3;
    final adCounter = ref.read(adCounterProvider.notifier);

    if (!forceShow) {
      adCounter.incrementAction();
      if (!adCounter.shouldShowAd(fullAdsInterval)) {
        devLogger('Ad not shown - interval not reached.');
        await action();
        return;
      }
    }

    final adHelper = ref.read(interstitialAdProvider.notifier);
    await adHelper.loadAd();

    if (adHelper.isAdAvailable) {
      adHelper.showAd(
        onAdDismissed: () async {
          if (!forceShow) {
            adCounter.resetAfterAd();
          }
          await action();
        },
        onAdFailed: () async {
          if (!forceShow) {
            adCounter.resetAfterAd();
          }
          await action();
        },
      );
      return;
    }

    devLogger('Ad not shown - ad not available.');
    await action();
  }

  static Future<void> performActionWithRewardedAd(
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    if (!_shouldShowAds(ref)) {
      devLogger('Rewarded ad not shown - user is premium or showVideoAds is off.');
      await action();
      return;
    }

    final adCounter = ref.read(adCounterProvider.notifier);
    final shouldShowRewarded = adCounter.shouldShowRewardedAd();

    if (!shouldShowRewarded) {
      performActionWithAd(ref, action);
      return;
    }

    final rewardedAdHelper = ref.read(rewardedAdProvider.notifier);
    await rewardedAdHelper.loadAd();

    if (rewardedAdHelper.isAdAvailable) {
      rewardedAdHelper.showAd(
        onAdDismissed: () async {
          adCounter.resetAfterAd();
          await action();
        },
        onAdFailed: () async {
          performActionWithAd(ref, action);
        },
        onUserEarnedReward: () {
          rewardedAdHelper.loadAd();
        },
      );
      return;
    }

    devLogger('Rewarded ad not available, showing interstitial instead.');
    performActionWithAd(ref, action);
  }
}

