// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalVerse _$DevotionalVerseFromJson(Map<String, dynamic> json) =>
    DevotionalVerse(
      id: (json['id'] as num?)?.toInt(),
      ref: json['ref'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$DevotionalVerseToJson(DevotionalVerse instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.ref case final value?) 'ref': value,
      if (instance.text case final value?) 'text': value,
    };
