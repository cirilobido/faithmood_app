import 'package:json_annotation/json_annotation.dart';

import '_mood.dart';

part '_mood_session_emotional.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSessionEmotional {
  final int? id;
  final int? userId;
  final int? moodId;
  final String? note;
  final String? sessionId;
  final String? aiReflection;
  final int? aiVerseId;
  final int? emotionLevel;
  final String? lang;
  final bool? isPrivate;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Mood? mood;

  MoodSessionEmotional({
    this.id,
    this.userId,
    this.moodId,
    this.note,
    this.sessionId,
    this.aiReflection,
    this.aiVerseId,
    this.emotionLevel,
    this.lang,
    this.isPrivate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.mood,
  });

  factory MoodSessionEmotional.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionEmotionalFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionEmotionalToJson(this);
}

