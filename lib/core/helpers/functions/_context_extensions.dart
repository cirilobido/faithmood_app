import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../dev_utils/_logger.dart';
import '../../core_exports.dart';

extension ContextExtension on BuildContext {
  Future<void> pushWithAnalytics(WidgetRef ref, String route, {Object? extra}) async {
    final analytics = ref.read(firebaseAnalyticProvider);
    analytics.logEvent(
      name: 'push_with_analytics',
      parameters: {'screen': route, 'extra': extra.toString()},
    );
    push(route, extra: extra);
  }

  Future<void> goWithAnalytics(WidgetRef ref, String route, {Object? extra}) async {
    final analytics = ref.read(firebaseAnalyticProvider);
    analytics.logEvent(
      name: 'go_with_analytics',
      parameters: {'screen': route, 'extra': extra.toString()},
    );
    go(route, extra: extra);
  }

  Future<void> pushWithAd(
    WidgetRef ref,
    String route, {
    Object? extra,
    bool forceShow = false,
    bool popBeforePush = false,
  }) async {
    final analytics = ref.read(firebaseAnalyticProvider);
    analytics.logEvent(
      name: 'push_with_ad',
      parameters: {'screen': route, 'extra': extra.toString()},
    );

    final auth = ref.read(authProvider);
    final settings = ref.read(settingsProvider);
    final isPremium = auth.user?.planType != PlanName.FREE;
    final showVideoAds = settings.settings?.showVideoAds ?? false;

    if (isPremium || !showVideoAds) {
      devLogger('Ad not shown - user is premium or showVideoAds is off.');
      try {
        if (popBeforePush && canPop()) {
          pop();
        }
        push(route, extra: extra);
      } catch (e) {
        devLogger('Navigation failed: $e');
      }
      return;
    }

    final adCounter = ref.read(adCounterProvider.notifier);
    
    if (!forceShow) {
      adCounter.incrementAction();
      final fullAdsInterval = settings.settings?.fullAdsInterval ?? 3;

      if (!adCounter.shouldShowAd(fullAdsInterval)) {
        devLogger('Ad not shown - interval not reached.');
        try {
          if (popBeforePush && canPop()) {
            pop();
          }
          push(route, extra: extra);
        } catch (e) {
          devLogger('Navigation failed: $e');
        }
        return;
      }
    }

    final shouldShowRewarded = !forceShow && adCounter.shouldShowRewardedAd();

    if (shouldShowRewarded) {
      final rewardedAdHelper = ref.read(rewardedAdProvider.notifier);
      await rewardedAdHelper.loadAd();

      if (rewardedAdHelper.isAdAvailable) {
        rewardedAdHelper.showAd(
          onAdDismissed: () {
            if (!forceShow) {
              adCounter.resetAfterAd();
            }
            try {
              if (popBeforePush && canPop()) {
                pop();
              }
              push(route, extra: extra);
            } catch (e) {
              devLogger('Navigation failed after rewarded ad: $e');
            }
          },
          onAdFailed: () {
            final interstitialHelper = ref.read(interstitialAdProvider.notifier);
            interstitialHelper.loadAd().then((_) {
              if (interstitialHelper.isAdAvailable) {
                interstitialHelper.showAd(
                  onAdDismissed: () {
                    if (!forceShow) {
                      adCounter.resetAfterAd();
                    }
                    try {
                      if (popBeforePush && canPop()) {
                        pop();
                      }
                      push(route, extra: extra);
                    } catch (e) {
                      devLogger('Navigation failed after interstitial fallback: $e');
                    }
                  },
                  onAdFailed: () {
                    if (!forceShow) {
                      adCounter.resetAfterAd();
                    }
                    try {
                      if (popBeforePush && canPop()) {
                        pop();
                      }
                      push(route, extra: extra);
                    } catch (e) {
                      devLogger('Navigation failed after interstitial fallback failed: $e');
                    }
                  },
                );
              } else {
                if (!forceShow) {
                  adCounter.resetAfterAd();
                }
                try {
                  if (popBeforePush && canPop()) {
                    pop();
                  }
                  push(route, extra: extra);
                } catch (e) {
                  devLogger('Navigation failed after rewarded ad failed: $e');
                }
              }
            });
          },
          onUserEarnedReward: () {
            rewardedAdHelper.loadAd();
          },
        );
        return;
      }
    }

    final adHelper = ref.read(interstitialAdProvider.notifier);
    await adHelper.loadAd();

    if (adHelper.isAdAvailable) {
      adHelper.showAd(
        onAdDismissed: () {
          if (!forceShow) {
            adCounter.resetAfterAd();
          }
          try {
            if (popBeforePush && canPop()) {
              pop();
            }
            push(route, extra: extra);
          } catch (e) {
            devLogger('Navigation failed after interstitial ad: $e');
          }
        },
        onAdFailed: () {
          if (!forceShow) {
            adCounter.resetAfterAd();
          }
          try {
            if (popBeforePush && canPop()) {
              pop();
            }
            push(route, extra: extra);
          } catch (e) {
            devLogger('Navigation failed after interstitial ad failed: $e');
          }
        },
      );
      return;
    }

    devLogger('Ad not shown - ad not available.');
    try {
      if (popBeforePush && canPop()) {
        pop();
      }
      push(route, extra: extra);
    } catch (e) {
      devLogger('Navigation failed: $e');
    }
  }
}
