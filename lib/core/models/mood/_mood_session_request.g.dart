// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood_session_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodSessionRequest _$MoodSessionRequestFromJson(Map<String, dynamic> json) =>
    MoodSessionRequest(
      userId: (json['userId'] as num?)?.toInt(),
      emotionalMoodId: (json['emotionalMoodId'] as num?)?.toInt(),
      spiritualMoodId: (json['spiritualMoodId'] as num?)?.toInt(),
      note: json['note'] as String?,
      emotionLevel: (json['emotionLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MoodSessionRequestToJson(MoodSessionRequest instance) =>
    <String, dynamic>{
      if (instance.userId case final value?) 'userId': value,
      if (instance.emotionalMoodId case final value?) 'emotionalMoodId': value,
      if (instance.spiritualMoodId case final value?) 'spiritualMoodId': value,
      if (instance.note case final value?) 'note': value,
      if (instance.emotionLevel case final value?) 'emotionLevel': value,
    };
