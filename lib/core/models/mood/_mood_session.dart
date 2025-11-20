import 'package:json_annotation/json_annotation.dart';

import '_mood_session_emotional.dart';
import '_mood_session_spiritual.dart';
import '_mood_session_verse.dart';

part '_mood_session.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSession {
  final String? sessionId;
  @JsonKey(name: 'date')
  final DateTime? date;
  final String? note;
  final MoodSessionEmotional? emotional;
  final MoodSessionSpiritual? spiritual;
  @JsonKey(name: 'aiVerse')
  final MoodSessionVerse? aiVerse;

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

