import 'package:json_annotation/json_annotation.dart';

import '../../core_exports.dart';

part '_user.g.dart';

@JsonSerializable(includeIfNull: false)
class User {
  final int? id;
  final String? deviceId;
  final String? name;
  final String? email;
  final int? age;
  final Lang? lang;
  final PlanName? planType;
  final bool? isActive;
  final DateTime? subscriptionEndsAt;
  final int? level;
  final int? experiencePoints;
  final String? fcmToken;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final UserSettings? settings;
  final dynamic lastMoodLog;
  final dynamic lastDevotional;
  final String? refreshToken;
  final String? refreshExpiration;
  final String? tokenExpiration;

  User({
    this.id,
    this.deviceId,
    this.name,
    this.email,
    this.age,
    this.lang,
    this.planType,
    this.isActive,
    this.subscriptionEndsAt,
    this.level,
    this.experiencePoints,
    this.fcmToken,
    this.lastLogin,
    this.createdAt,
    this.settings,
    this.lastMoodLog,
    this.lastDevotional,
    this.refreshToken,
    this.refreshExpiration,
    this.tokenExpiration,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? deviceId,
    String? name,
    String? email,
    int? age,
    Lang? lang,
    PlanName? planType,
    bool? isActive,
    DateTime? subscriptionEndsAt,
    int? level,
    int? experiencePoints,
    String? fcmToken,
    DateTime? lastLogin,
    DateTime? createdAt,
    UserSettings? settings,
    dynamic lastMoodLog,
    dynamic lastDevotional,
    String? refreshToken,
    String? refreshExpiration,
    String? tokenExpiration,
  }) {
    return User(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      lang: lang ?? this.lang,
      planType: planType ?? this.planType,
      isActive: isActive ?? this.isActive,
      subscriptionEndsAt: subscriptionEndsAt ?? this.subscriptionEndsAt,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      fcmToken: fcmToken ?? this.fcmToken,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
      lastMoodLog: lastMoodLog ?? this.lastMoodLog,
      lastDevotional: lastDevotional ?? this.lastDevotional,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshExpiration: refreshExpiration ?? this.refreshExpiration,
      tokenExpiration: tokenExpiration ?? this.tokenExpiration,
    );
  }
}
