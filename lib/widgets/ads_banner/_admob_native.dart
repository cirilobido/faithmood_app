import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/_logger.dart';

class NativeAdmobAd extends StatefulWidget {
  final bool isNativeBanner;
  final bool? isBigBanner;

  const NativeAdmobAd({
    super.key,
    this.isNativeBanner = true,
    this.isBigBanner = false,
  });

  @override
  State<NativeAdmobAd> createState() => _NativeAdmobAdState();
}

class _NativeAdmobAdState extends State<NativeAdmobAd> {
  NativeAd? _nativeAd;
  BannerAd? _bannerAd;
  bool _isNativeAdLoaded = false;
  final String _nativeAdUnitId = Constant.admobNativeAdUnitId;

  final String _bannerAdUnitId = Constant.admobBannerAdUnitId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isNativeBanner) {
        _loadNativeAd(context);
      } else {
        _loadBannerAd();
      }
    });
  }

  void _loadNativeAd(BuildContext context) {
    final theme = Theme.of(context);
    _nativeAd = NativeAd(
      adUnitId: _nativeAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          devLogger('$NativeAd loaded.');
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          devLogger('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        // Called when a click is recorded for a NativeAd.
        onAdClicked: (ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (ad) {},
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (ad) {},
        // For iOS only. Called before dismissing a full screen view
        onAdWillDismissScreen: (ad) {},
        // Called when an ad receives revenue value.
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType: widget.isBigBanner!
            ? TemplateType.medium
            : TemplateType.small,
        // Optional: Customize the ad's style.
        mainBackgroundColor: theme.colorScheme.surface,
        cornerRadius: AppSizes.radiusSmall,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: theme.textTheme.bodyLarge?.color,
          backgroundColor: theme.colorScheme.primary,
          style: NativeTemplateFontStyle.bold,
          size: theme.textTheme.bodyLarge?.fontSize,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: theme.textTheme.bodyLarge?.color,
          style: NativeTemplateFontStyle.italic,
          size: theme.textTheme.bodyLarge?.fontSize,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: theme.textTheme.labelSmall?.color,
          style: NativeTemplateFontStyle.bold,
          size: theme.textTheme.bodyMedium?.fontSize,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: theme.colorScheme.secondary,
          style: NativeTemplateFontStyle.normal,
          size: theme.textTheme.labelMedium?.fontSize,
        ),
      ),
    )..load();
  }

  void _loadBannerAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      devLogger('Unable to get width of anchored banner.');
      // Unable to get width of anchored banner.
      return;
    }

    BannerAd(
      adUnitId: _bannerAdUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          devLogger("Ad was loaded.");
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          devLogger("Ad failed to load with error: $err");
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.isNativeBanner) {
      if (!_isNativeAdLoaded) return const SizedBox.shrink();
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingSmall),
          height: widget.isBigBanner! ? 360 : AppSizes.bannerAdHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadiusDirectional.circular(AppSizes.radiusSmall),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.isBigBanner! ? 320 : AppSizes.bannerAdHeight + 10,
              maxHeight: widget.isBigBanner! ? 400 : 200,
            ),
            child: Center(child: AdWidget(ad: _nativeAd!)),
          ),
        ),
      );
    } else {
      if (_bannerAd == null) return const SizedBox.shrink();
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: widget.isBigBanner! ? 320 : _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
  }
}
