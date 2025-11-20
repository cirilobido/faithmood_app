import 'package:json_annotation/json_annotation.dart';

part '_mood_session_request.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSessionRequest {
  final int? userId;
  final int? emotionalMoodId;
  final int? spiritualMoodId;
  final String? note;
  final int? emotionLevel;

  MoodSessionRequest({
    this.userId,
    this.emotionalMoodId,
    this.spiritualMoodId,
    this.note,
    this.emotionLevel,
  });

  factory MoodSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionRequestToJson(this);
}

