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
  password: json['password'] as String?,
  newPassword: json['newPassword'] as String?,
  age: (json['age'] as num?)?.toInt(),
  lang: $enumDecodeNullable(_$LangEnumMap, json['lang']),
  planType: $enumDecodeNullable(_$PlanNameEnumMap, json['planType']),
  maxDailyRequest: (json['maxDailyRequest'] as num?)?.toInt(),
  countDreams: (json['countDreams'] as num?)?.toInt(),
  todayDreams: (json['todayDreams'] as num?)?.toInt(),
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.deviceId case final value?) 'deviceId': value,
  if (instance.name case final value?) 'name': value,
  if (instance.email case final value?) 'email': value,
  if (instance.password case final value?) 'password': value,
  if (instance.newPassword case final value?) 'newPassword': value,
  if (instance.age case final value?) 'age': value,
  if (_$LangEnumMap[instance.lang] case final value?) 'lang': value,
  if (_$PlanNameEnumMap[instance.planType] case final value?) 'planType': value,
  if (instance.maxDailyRequest case final value?) 'maxDailyRequest': value,
  if (instance.countDreams case final value?) 'countDreams': value,
  if (instance.todayDreams case final value?) 'todayDreams': value,
  if (instance.isActive case final value?) 'isActive': value,
};

const _$LangEnumMap = {Lang.en: 'en', Lang.es: 'es', Lang.pt: 'pt'};

const _$PlanNameEnumMap = {PlanName.FREE: 'FREE', PlanName.PREMIUM: 'PREMIUM'};
