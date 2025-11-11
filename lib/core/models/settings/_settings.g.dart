// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  appVersion: json['currentVersion'] as String?,
  maxCharsDreamFree: (json['maxCharsDreamFree'] as num?)?.toInt(),
  maxCharsDreamPro: (json['maxCharsDreamPro'] as num?)?.toInt(),
  fullAdsInterval: (json['fullAdsInterval'] as num?)?.toInt(),
  showBannerAds: json['showBannerAds'] as bool?,
  showVideoAds: json['showVideoAds'] as bool?,
  appUpdateUrlAndroid: json['updateUrl'] as String?,
  appUpdateUrlIos: json['appUpdateUrlIos'] as String?,
  rateUrlAndroid: json['rateUrl'] as String?,
  rateUrlIos: json['rateUrlIos'] as String?,
  storeSubUrl: json['storeSubUrl'] as String?,
  storeSubUrlIos: json['storeSubUrlIos'] as String?,
  followUrl: json['followUrl'] as String?,
  shareUrl: json['shareUrl'] as String?,
  contactUrl: json['contactUrl'] as String?,
  termsUrl: json['termsUrl'] as String?,
  privacyUrl: json['privacyUrl'] as String?,
  aboutUrl: json['aboutUrl'] as String?,
  reportUrl: json['reportUrl'] as String?,
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  if (instance.appVersion case final value?) 'currentVersion': value,
  if (instance.maxCharsDreamFree case final value?) 'maxCharsDreamFree': value,
  if (instance.maxCharsDreamPro case final value?) 'maxCharsDreamPro': value,
  if (instance.fullAdsInterval case final value?) 'fullAdsInterval': value,
  if (instance.showBannerAds case final value?) 'showBannerAds': value,
  if (instance.showVideoAds case final value?) 'showVideoAds': value,
  if (instance.appUpdateUrlAndroid case final value?) 'updateUrl': value,
  if (instance.appUpdateUrlIos case final value?) 'appUpdateUrlIos': value,
  if (instance.rateUrlAndroid case final value?) 'rateUrl': value,
  if (instance.rateUrlIos case final value?) 'rateUrlIos': value,
  if (instance.storeSubUrl case final value?) 'storeSubUrl': value,
  if (instance.storeSubUrlIos case final value?) 'storeSubUrlIos': value,
  if (instance.followUrl case final value?) 'followUrl': value,
  if (instance.shareUrl case final value?) 'shareUrl': value,
  if (instance.contactUrl case final value?) 'contactUrl': value,
  if (instance.termsUrl case final value?) 'termsUrl': value,
  if (instance.privacyUrl case final value?) 'privacyUrl': value,
  if (instance.aboutUrl case final value?) 'aboutUrl': value,
  if (instance.reportUrl case final value?) 'reportUrl': value,
};
