import 'package:json_annotation/json_annotation.dart';

part '_mood_session_mood.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSessionMood {
  final int? id;
  final String? name;
  final int? emotionLevel;

  MoodSessionMood({
    this.id,
    this.name,
    this.emotionLevel,
  });

  factory MoodSessionMood.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionMoodFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionMoodToJson(this);
}

