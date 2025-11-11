// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) => AuthRequest(
  id: json['id'] as String?,
  name: json['name'] as String?,
  age: (json['age'] as num?)?.toInt(),
  email: json['email'] as String?,
  password: json['password'] as String?,
  lang: $enumDecodeNullable(_$LangEnumMap, json['lang']),
  otpCode: json['otpCode'] as String?,
  newPassword: json['newPassword'] as String?,
  fcmToken: json['fcmToken'] as String?,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$AuthRequestToJson(AuthRequest instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.age case final value?) 'age': value,
      if (instance.email case final value?) 'email': value,
      if (instance.password case final value?) 'password': value,
      if (_$LangEnumMap[instance.lang] case final value?) 'lang': value,
      if (instance.otpCode case final value?) 'otpCode': value,
      if (instance.newPassword case final value?) 'newPassword': value,
      if (instance.fcmToken case final value?) 'fcmToken': value,
      if (instance.timezone case final value?) 'timezone': value,
    };

const _$LangEnumMap = {Lang.en: 'en', Lang.es: 'es', Lang.pt: 'pt'};
