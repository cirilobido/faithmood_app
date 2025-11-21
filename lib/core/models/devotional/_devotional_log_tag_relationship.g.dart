// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log_tag_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogTagRelationship _$DevotionalLogTagRelationshipFromJson(
  Map<String, dynamic> json,
) => DevotionalLogTagRelationship(
  id: (json['id'] as num?)?.toInt(),
  devotionalId: (json['devotionalId'] as num?)?.toInt(),
  tagId: (json['tagId'] as num?)?.toInt(),
  tag: json['tag'] == null
      ? null
      : Tag.fromJson(json['tag'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DevotionalLogTagRelationshipToJson(
  DevotionalLogTagRelationship instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.devotionalId case final value?) 'devotionalId': value,
  if (instance.tagId case final value?) 'tagId': value,
  if (instance.tag case final value?) 'tag': value,
};
