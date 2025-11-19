// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_verse_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseBook _$VerseBookFromJson(Map<String, dynamic> json) => VerseBook(
  key: json['key'] as String?,
  name: json['name'] as String?,
  chapter: (json['chapter'] as num?)?.toInt(),
  verseNumber: (json['verseNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$VerseBookToJson(VerseBook instance) => <String, dynamic>{
  if (instance.key case final value?) 'key': value,
  if (instance.name case final value?) 'name': value,
  if (instance.chapter case final value?) 'chapter': value,
  if (instance.verseNumber case final value?) 'verseNumber': value,
};
