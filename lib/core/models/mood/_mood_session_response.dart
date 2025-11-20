import 'package:json_annotation/json_annotation.dart';

part '_mood_session_response.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSessionResponse {
  final String? sessionId;
  final String? message;

  MoodSessionResponse({
    this.sessionId,
    this.message,
  });

  factory MoodSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionResponseToJson(this);
}

