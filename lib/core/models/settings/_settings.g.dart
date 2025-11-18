// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  maxCharsNoteFree: (json['maxCharsNoteFree'] as num?)?.toInt(),
  maxCharsNotePro: (json['maxCharsNotePro'] as num?)?.toInt(),
  aiDailyLimitFree: (json['aiDailyLimitFree'] as num?)?.toInt(),
  aiDailyLimitPro: (json['aiDailyLimitPro'] as num?)?.toInt(),
  fullAdsInterval: (json['fullAdsInterval'] as num?)?.toInt(),
  showBannerAds: json['showBannerAds'] as bool?,
  showVideoAds: json['showVideoAds'] as bool?,
  onboardingScreens: (json['onboardingScreens'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  showDevotionals: json['showDevotionals'] as bool?,
  showMoods: json['showMoods'] as bool?,
  rateRequestAfter: (json['rateRequestAfter'] as num?)?.toInt(),
  payRequestAfter: (json['payRequestAfter'] as num?)?.toInt(),
  minAppRatingPrompt: (json['minAppRatingPrompt'] as num?)?.toInt(),
  maintenanceMode: json['maintenanceMode'] as bool?,
  appVersion: json['currentVersion'] as String?,
  minSupportedVersion: json['minSupportedVersion'] as String?,
  forceUpdate: json['forceUpdate'] as bool?,
  featureFlags: json['featureFlags'] as Map<String, dynamic>?,
  updateBaseUrl: json['updateBaseUrl'] as String?,
  supportUrl: json['supportUrl'] as String?,
  followUrl: json['followUrl'] as String?,
  shareUrl: json['shareUrl'] as String?,
  termsUrl: json['termsUrl'] as String?,
  privacyUrl: json['privacyUrl'] as String?,
  appLanguages: (json['appLanguages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  if (instance.maxCharsNoteFree case final value?) 'maxCharsNoteFree': value,
  if (instance.maxCharsNotePro case final value?) 'maxCharsNotePro': value,
  if (instance.aiDailyLimitFree case final value?) 'aiDailyLimitFree': value,
  if (instance.aiDailyLimitPro case final value?) 'aiDailyLimitPro': value,
  if (instance.fullAdsInterval case final value?) 'fullAdsInterval': value,
  if (instance.showBannerAds case final value?) 'showBannerAds': value,
  if (instance.showVideoAds case final value?) 'showVideoAds': value,
  if (instance.onboardingScreens case final value?) 'onboardingScreens': value,
  if (instance.showDevotionals case final value?) 'showDevotionals': value,
  if (instance.showMoods case final value?) 'showMoods': value,
  if (instance.rateRequestAfter case final value?) 'rateRequestAfter': value,
  if (instance.payRequestAfter case final value?) 'payRequestAfter': value,
  if (instance.minAppRatingPrompt case final value?)
    'minAppRatingPrompt': value,
  if (instance.maintenanceMode case final value?) 'maintenanceMode': value,
  if (instance.appVersion case final value?) 'currentVersion': value,
  if (instance.minSupportedVersion case final value?)
    'minSupportedVersion': value,
  if (instance.forceUpdate case final value?) 'forceUpdate': value,
  if (instance.featureFlags case final value?) 'featureFlags': value,
  if (instance.updateBaseUrl case final value?) 'updateBaseUrl': value,
  if (instance.supportUrl case final value?) 'supportUrl': value,
  if (instance.followUrl case final value?) 'followUrl': value,
  if (instance.shareUrl case final value?) 'shareUrl': value,
  if (instance.termsUrl case final value?) 'termsUrl': value,
  if (instance.privacyUrl case final value?) 'privacyUrl': value,
  if (instance.appLanguages case final value?) 'appLanguages': value,
  if (instance.createdAt?.toIso8601String() case final value?)
    'createdAt': value,
  if (instance.updatedAt?.toIso8601String() case final value?)
    'updatedAt': value,
};
