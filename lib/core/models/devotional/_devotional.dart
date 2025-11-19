import 'package:json_annotation/json_annotation.dart';

import '_devotional_category.dart';
import '_devotional_tag.dart';
import '_devotional_verse.dart';

part '_devotional.g.dart';

@JsonSerializable(includeIfNull: false)
class Devotional {
  final int? id;
  final String? date;
  final String? coverImage;
  final bool? isPremium;
  final DevotionalCategory? category;
  final String? title;
  final String? content;
  final String? reflection;
  final List<DevotionalVerse>? verses;
  final List<DevotionalTag>? tags;
  final String? iconEmoji;

  Devotional({
    this.id,
    this.date,
    this.coverImage,
    this.isPremium,
    this.category,
    this.title,
    this.content,
    this.reflection,
    this.verses,
    this.tags,
    this.iconEmoji,
  });

  factory Devotional.fromJson(Map<String, dynamic> json) =>
      _$DevotionalFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalToJson(this);
}

