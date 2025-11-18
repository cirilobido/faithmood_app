// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verse _$VerseFromJson(Map<String, dynamic> json) => Verse(
  id: (json['id'] as num?)?.toInt(),
  ref: json['ref'] as String?,
  text: json['text'] as String?,
  lang: json['lang'] as String?,
  book: json['book'] == null
      ? null
      : VerseBook.fromJson(json['book'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$VerseToJson(Verse instance) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.ref case final value?) 'ref': value,
  if (instance.text case final value?) 'text': value,
  if (instance.lang case final value?) 'lang': value,
  if (instance.book case final value?) 'book': value,
  if (instance.createdAt?.toIso8601String() case final value?)
    'createdAt': value,
};
