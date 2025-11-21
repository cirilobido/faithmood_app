// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Devotional _$DevotionalFromJson(Map<String, dynamic> json) => Devotional(
  id: (json['id'] as num?)?.toInt(),
  date: json['date'] as String?,
  coverImage: json['coverImage'] as String?,
  isPremium: json['isPremium'] as bool?,
  category: json['category'] == null
      ? null
      : DevotionalCategory.fromJson(json['category'] as Map<String, dynamic>),
  title: json['title'] as String?,
  content: json['content'] as String?,
  reflection: json['reflection'] as String?,
  verses: (json['verses'] as List<dynamic>?)
      ?.map((e) => Verse.fromJson(e as Map<String, dynamic>))
      .toList(),
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
      .toList(),
  iconEmoji: json['iconEmoji'] as String?,
);

Map<String, dynamic> _$DevotionalToJson(Devotional instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.date case final value?) 'date': value,
      if (instance.coverImage case final value?) 'coverImage': value,
      if (instance.isPremium case final value?) 'isPremium': value,
      if (instance.category case final value?) 'category': value,
      if (instance.title case final value?) 'title': value,
      if (instance.content case final value?) 'content': value,
      if (instance.reflection case final value?) 'reflection': value,
      if (instance.verses case final value?) 'verses': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.iconEmoji case final value?) 'iconEmoji': value,
    };
