// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodSession _$MoodSessionFromJson(Map<String, dynamic> json) => MoodSession(
  sessionId: json['sessionId'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  note: json['note'] as String?,
  emotional: json['emotional'] == null
      ? null
      : MoodSessionEmotional.fromJson(
          json['emotional'] as Map<String, dynamic>,
        ),
  spiritual: json['spiritual'] == null
      ? null
      : MoodSessionSpiritual.fromJson(
          json['spiritual'] as Map<String, dynamic>,
        ),
  aiVerse: json['aiVerse'] == null
      ? null
      : MoodSessionVerse.fromJson(json['aiVerse'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MoodSessionToJson(MoodSession instance) =>
    <String, dynamic>{
      if (instance.sessionId case final value?) 'sessionId': value,
      if (instance.date?.toIso8601String() case final value?) 'date': value,
      if (instance.note case final value?) 'note': value,
      if (instance.emotional case final value?) 'emotional': value,
      if (instance.spiritual case final value?) 'spiritual': value,
      if (instance.aiVerse case final value?) 'aiVerse': value,
    };
