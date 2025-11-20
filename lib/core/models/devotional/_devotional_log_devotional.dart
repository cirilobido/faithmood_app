import 'package:json_annotation/json_annotation.dart';

import '_devotional_log_tag_relationship.dart';
import '_devotional_log_verse_relationship.dart';
import '_devotional_category.dart';

part '_devotional_log_devotional.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogDevotional {
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

  DevotionalLogDevotional({
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

  factory DevotionalLogDevotional.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogDevotionalFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogDevotionalToJson(this);
}
