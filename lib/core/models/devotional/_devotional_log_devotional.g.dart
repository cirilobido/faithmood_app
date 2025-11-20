// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log_devotional.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogDevotional _$DevotionalLogDevotionalFromJson(
  Map<String, dynamic> json,
) => DevotionalLogDevotional(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  reflection: json['reflection'] as String?,
  iconEmoji: json['iconEmoji'] as String?,
  date: json['date'] as String?,
  tags: (json['tags'] as List<dynamic>?)
      ?.map(
        (e) => DevotionalLogTagRelationship.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  verses: (json['verses'] as List<dynamic>?)
      ?.map(
        (e) =>
            DevotionalLogVerseRelationship.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  category: json['category'] == null
      ? null
      : DevotionalCategory.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DevotionalLogDevotionalToJson(
  DevotionalLogDevotional instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.title case final value?) 'title': value,
  if (instance.content case final value?) 'content': value,
  if (instance.reflection case final value?) 'reflection': value,
  if (instance.iconEmoji case final value?) 'iconEmoji': value,
  if (instance.date case final value?) 'date': value,
  if (instance.tags case final value?) 'tags': value,
  if (instance.verses case final value?) 'verses': value,
  if (instance.category case final value?) 'category': value,
};
