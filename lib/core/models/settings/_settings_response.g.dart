// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsResponse _$SettingsResponseFromJson(Map<String, dynamic> json) =>
    SettingsResponse(
      message: json['message'] as String?,
      settings: json['settings'] == null
          ? null
          : Settings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsResponseToJson(SettingsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'settings': instance.settings,
    };
