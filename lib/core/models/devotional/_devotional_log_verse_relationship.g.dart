// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log_verse_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogVerseRelationship _$DevotionalLogVerseRelationshipFromJson(
  Map<String, dynamic> json,
) => DevotionalLogVerseRelationship(
  id: (json['id'] as num?)?.toInt(),
  devotionalId: (json['devotionalId'] as num?)?.toInt(),
  verseId: (json['verseId'] as num?)?.toInt(),
  verse: json['verse'] == null
      ? null
      : Verse.fromJson(json['verse'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DevotionalLogVerseRelationshipToJson(
  DevotionalLogVerseRelationship instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.devotionalId case final value?) 'devotionalId': value,
  if (instance.verseId case final value?) 'verseId': value,
  if (instance.verse case final value?) 'verse': value,
};
