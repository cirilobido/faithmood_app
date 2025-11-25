// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood_session_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodSessionDetails _$MoodSessionDetailsFromJson(Map<String, dynamic> json) =>
    MoodSessionDetails(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      moodId: (json['moodId'] as num?)?.toInt(),
      note: json['note'] as String?,
      sessionId: json['sessionId'] as String?,
      aiReflection: json['aiReflection'] as String?,
      aiVerseId: (json['aiVerseId'] as num?)?.toInt(),
      emotionLevel: (json['emotionLevel'] as num?)?.toInt(),
      lang: json['lang'] as String?,
      isPrivate: json['isPrivate'] as bool?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      mood: json['mood'] == null
          ? null
          : Mood.fromJson(json['mood'] as Map<String, dynamic>),
      aiVerse: json['aiVerse'] == null
          ? null
          : Verse.fromJson(json['aiVerse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MoodSessionDetailsToJson(MoodSessionDetails instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.moodId case final value?) 'moodId': value,
      if (instance.note case final value?) 'note': value,
      if (instance.sessionId case final value?) 'sessionId': value,
      if (instance.aiReflection case final value?) 'aiReflection': value,
      if (instance.aiVerseId case final value?) 'aiVerseId': value,
      if (instance.emotionLevel case final value?) 'emotionLevel': value,
      if (instance.lang case final value?) 'lang': value,
      if (instance.isPrivate case final value?) 'isPrivate': value,
      if (instance.isActive case final value?) 'isActive': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      if (instance.mood case final value?) 'mood': value,
      if (instance.aiVerse case final value?) 'aiVerse': value,
    };
