// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood_session_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodSessionVerse _$MoodSessionVerseFromJson(Map<String, dynamic> json) =>
    MoodSessionVerse(
      id: (json['id'] as num?)?.toInt(),
      bookKey: json['bookKey'] as String?,
      chapter: (json['chapter'] as num?)?.toInt(),
      verseNumber: (json['verseNumber'] as num?)?.toInt(),
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => VerseTranslation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MoodSessionVerseToJson(MoodSessionVerse instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.bookKey case final value?) 'bookKey': value,
      if (instance.chapter case final value?) 'chapter': value,
      if (instance.verseNumber case final value?) 'verseNumber': value,
      if (instance.translations case final value?) 'translations': value,
    };
