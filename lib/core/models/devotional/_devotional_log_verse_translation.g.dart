// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log_verse_translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogVerseTranslation _$DevotionalLogVerseTranslationFromJson(
  Map<String, dynamic> json,
) => DevotionalLogVerseTranslation(
  id: (json['id'] as num?)?.toInt(),
  verseId: (json['verseId'] as num?)?.toInt(),
  lang: json['lang'] as String?,
  ref: json['ref'] as String?,
  text: json['text'] as String?,
);

Map<String, dynamic> _$DevotionalLogVerseTranslationToJson(
  DevotionalLogVerseTranslation instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.verseId case final value?) 'verseId': value,
  if (instance.lang case final value?) 'lang': value,
  if (instance.ref case final value?) 'ref': value,
  if (instance.text case final value?) 'text': value,
};
