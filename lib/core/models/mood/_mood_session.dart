import 'package:json_annotation/json_annotation.dart';

import '../verse/_verse.dart';
import '_mood_session_details.dart';

part '_mood_session.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSession {
  final String? sessionId;
  @JsonKey(name: 'date')
  final DateTime? date;
  final String? note;
  final MoodSessionDetails? emotional;
  final MoodSessionDetails? spiritual;
  @JsonKey(name: 'aiVerse')
  final Verse? aiVerse;

  MoodSession({
    this.sessionId,
    this.date,
    this.note,
    this.emotional,
    this.spiritual,
    this.aiVerse,
  });

  factory MoodSession.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionToJson(this);
}

