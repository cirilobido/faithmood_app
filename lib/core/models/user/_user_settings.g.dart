// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
  notificationsEnabled: json['notificationsEnabled'] as bool?,
  aiAnalysisEnabled: json['aiAnalysisEnabled'] as bool?,
  timezone: json['timezone'] as String?,
  darkMode: json['darkMode'] as bool?,
);

Map<String, dynamic> _$UserSettingsToJson(
  UserSettings instance,
) => <String, dynamic>{
  if (instance.notificationsEnabled case final value?)
    'notificationsEnabled': value,
  if (instance.aiAnalysisEnabled case final value?) 'aiAnalysisEnabled': value,
  if (instance.timezone case final value?) 'timezone': value,
  if (instance.darkMode case final value?) 'darkMode': value,
};
