import 'package:json_annotation/json_annotation.dart';

import '_devotional_log_tag_relationship.dart';
import '_devotional_log_verse_relationship.dart';
import '_devotional_category.dart';

part '_devotional_log_content.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogContent {
  final int? id;
  final String? title;
  final String? content;
  final String? reflection;
  final String? iconEmoji;
  @JsonKey(name: 'date')
  final String? date;
  final List<DevotionalLogTagRelationship>? tags;
  final List<DevotionalLogVerseRelationship>? verses;
  final DevotionalCategory? category;

  DevotionalLogContent({
    this.id,
    this.title,
    this.content,
    this.reflection,
    this.iconEmoji,
    this.date,
    this.tags,
    this.verses,
    this.category,
  });

  factory DevotionalLogContent.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogContentFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogContentToJson(this);
}
