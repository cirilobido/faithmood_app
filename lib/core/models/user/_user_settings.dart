import 'package:json_annotation/json_annotation.dart';

part '_user_settings.g.dart';

@JsonSerializable(includeIfNull: false)
class UserSettings {
  final bool? notificationsEnabled;
  final bool? aiAnalysisEnabled;
  final String? timezone;
  final bool? darkMode;

  UserSettings({
    this.notificationsEnabled,
    this.aiAnalysisEnabled,
    this.timezone,
    this.darkMode,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({
    bool? notificationsEnabled,
    bool? aiAnalysisEnabled,
    String? timezone,
    bool? darkMode,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      aiAnalysisEnabled: aiAnalysisEnabled ?? this.aiAnalysisEnabled,
      timezone: timezone ?? this.timezone,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

