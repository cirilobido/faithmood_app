// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  deviceId: json['deviceId'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  age: (json['age'] as num?)?.toInt(),
  lang: $enumDecodeNullable(_$LangEnumMap, json['lang']),
  planType: $enumDecodeNullable(_$PlanNameEnumMap, json['planType']),
  isActive: json['isActive'] as bool?,
  subscriptionEndsAt: json['subscriptionEndsAt'] == null
      ? null
      : DateTime.parse(json['subscriptionEndsAt'] as String),
  level: (json['level'] as num?)?.toInt(),
  experiencePoints: (json['experiencePoints'] as num?)?.toInt(),
  fcmToken: json['fcmToken'] as String?,
  lastLogin: json['lastLogin'] == null
      ? null
      : DateTime.parse(json['lastLogin'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  settings: json['settings'] == null
      ? null
      : UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
  lastMoodLog: json['lastMoodLog'],
  lastDevotional: json['lastDevotional'],
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.deviceId case final value?) 'deviceId': value,
  if (instance.name case final value?) 'name': value,
  if (instance.email case final value?) 'email': value,
  if (instance.age case final value?) 'age': value,
  if (_$LangEnumMap[instance.lang] case final value?) 'lang': value,
  if (_$PlanNameEnumMap[instance.planType] case final value?) 'planType': value,
  if (instance.isActive case final value?) 'isActive': value,
  if (instance.subscriptionEndsAt?.toIso8601String() case final value?)
    'subscriptionEndsAt': value,
  if (instance.level case final value?) 'level': value,
  if (instance.experiencePoints case final value?) 'experiencePoints': value,
  if (instance.fcmToken case final value?) 'fcmToken': value,
  if (instance.lastLogin?.toIso8601String() case final value?)
    'lastLogin': value,
  if (instance.createdAt?.toIso8601String() case final value?)
    'createdAt': value,
  if (instance.settings case final value?) 'settings': value,
  if (instance.lastMoodLog case final value?) 'lastMoodLog': value,
  if (instance.lastDevotional case final value?) 'lastDevotional': value,
};

const _$LangEnumMap = {Lang.en: 'en', Lang.es: 'es', Lang.pt: 'pt'};

const _$PlanNameEnumMap = {PlanName.FREE: 'FREE', PlanName.PREMIUM: 'PREMIUM'};
