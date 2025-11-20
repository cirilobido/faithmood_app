// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogVerse _$DevotionalLogVerseFromJson(Map<String, dynamic> json) =>
    DevotionalLogVerse(
      id: (json['id'] as num?)?.toInt(),
      bookKey: json['bookKey'] as String?,
      chapter: (json['chapter'] as num?)?.toInt(),
      verseNumber: (json['verseNumber'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      translations: (json['translations'] as List<dynamic>?)
          ?.map(
            (e) => DevotionalLogVerseTranslation.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$DevotionalLogVerseToJson(DevotionalLogVerse instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.bookKey case final value?) 'bookKey': value,
      if (instance.chapter case final value?) 'chapter': value,
      if (instance.verseNumber case final value?) 'verseNumber': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.translations case final value?) 'translations': value,
    };
