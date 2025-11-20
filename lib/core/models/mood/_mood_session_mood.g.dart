// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood_session_mood.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodSessionMood _$MoodSessionMoodFromJson(Map<String, dynamic> json) =>
    MoodSessionMood(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      emotionLevel: (json['emotionLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MoodSessionMoodToJson(MoodSessionMood instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.emotionLevel case final value?) 'emotionLevel': value,
    };
