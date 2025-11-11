import 'package:json_annotation/json_annotation.dart';

import '_settings.dart';

part '_settings_response.g.dart';

@JsonSerializable()
class SettingsResponse {
  final String? message;
  final Settings? settings;

  SettingsResponse({
    this.message,
    this.settings,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsResponseToJson(this);
}
