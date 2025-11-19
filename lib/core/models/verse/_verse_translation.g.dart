// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_verse_translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseTranslation _$VerseTranslationFromJson(Map<String, dynamic> json) =>
    VerseTranslation(
      lang: json['lang'] as String?,
      ref: json['ref'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$VerseTranslationToJson(VerseTranslation instance) =>
    <String, dynamic>{
      if (instance.lang case final value?) 'lang': value,
      if (instance.ref case final value?) 'ref': value,
      if (instance.text case final value?) 'text': value,
    };
