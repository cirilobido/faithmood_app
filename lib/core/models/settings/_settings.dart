import 'package:json_annotation/json_annotation.dart';

part '_settings.g.dart';

@JsonSerializable(includeIfNull: false)
class Settings {

  @JsonKey(name: 'currentVersion')
  final String? appVersion;
  final int? maxCharsDreamFree;
  final int? maxCharsDreamPro;
  final int? fullAdsInterval;
  final bool? showBannerAds;
  final bool? showVideoAds;

  @JsonKey(name: 'updateUrl')
  final String? appUpdateUrlAndroid;
  final String? appUpdateUrlIos;
  @JsonKey(name: 'rateUrl')
  final String? rateUrlAndroid;
  final String? rateUrlIos;
  final String? storeSubUrl;
  final String? storeSubUrlIos;
  final String? followUrl;
  final String? shareUrl;
  final String? contactUrl;
  final String? termsUrl;
  final String? privacyUrl;
  final String? aboutUrl;
  final String? reportUrl;

  Settings({
    this.appVersion,
    this.maxCharsDreamFree,
    this.maxCharsDreamPro,
    this.fullAdsInterval,
    this.showBannerAds,
    this.showVideoAds,
    this.appUpdateUrlAndroid,
    this.appUpdateUrlIos,
    this.rateUrlAndroid,
    this.rateUrlIos,
    this.storeSubUrl,
    this.storeSubUrlIos,
    this.followUrl,
    this.shareUrl,
    this.contactUrl,
    this.termsUrl,
    this.privacyUrl,
    this.aboutUrl,
    this.reportUrl
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
