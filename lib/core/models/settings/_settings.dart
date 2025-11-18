import 'package:json_annotation/json_annotation.dart';

part '_settings.g.dart';

@JsonSerializable(includeIfNull: false)
class Settings {
  final int? maxCharsNoteFree;
  final int? maxCharsNotePro;
  final int? aiDailyLimitFree;
  final int? aiDailyLimitPro;
  final int? fullAdsInterval;
  final bool? showBannerAds;
  final bool? showVideoAds;
  final List<int>? onboardingScreens;
  final bool? showDevotionals;
  final bool? showMoods;
  final int? rateRequestAfter;
  final int? payRequestAfter;
  final int? minAppRatingPrompt;
  final bool? maintenanceMode;
  @JsonKey(name: 'currentVersion')
  final String? appVersion;
  final String? minSupportedVersion;
  final bool? forceUpdate;
  final Map<String, dynamic>? featureFlags;
  final String? updateBaseUrl;
  final String? supportUrl;
  final String? followUrl;
  final String? shareUrl;
  final String? termsUrl;
  final String? privacyUrl;
  final List<String>? appLanguages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Settings({
    this.maxCharsNoteFree,
    this.maxCharsNotePro,
    this.aiDailyLimitFree,
    this.aiDailyLimitPro,
    this.fullAdsInterval,
    this.showBannerAds,
    this.showVideoAds,
    this.onboardingScreens,
    this.showDevotionals,
    this.showMoods,
    this.rateRequestAfter,
    this.payRequestAfter,
    this.minAppRatingPrompt,
    this.maintenanceMode,
    this.appVersion,
    this.minSupportedVersion,
    this.forceUpdate,
    this.featureFlags,
    this.updateBaseUrl,
    this.supportUrl,
    this.followUrl,
    this.shareUrl,
    this.termsUrl,
    this.privacyUrl,
    this.appLanguages,
    this.createdAt,
    this.updatedAt,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
