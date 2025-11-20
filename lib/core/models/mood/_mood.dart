import 'package:json_annotation/json_annotation.dart';

import '_mood_tag.dart';

part '_mood.g.dart';

@JsonSerializable(includeIfNull: false)
class Mood {
  final int? id;
  final String? key;
  final String? name;
  final String? description;
  final String? category;
  final String? icon;
  final List<MoodTag>? tags;

  Mood({
    this.id,
    this.key,
    this.name,
    this.description,
    this.category,
    this.icon,
    this.tags,
  });

  factory Mood.fromJson(Map<String, dynamic> json) => _$MoodFromJson(json);

  Map<String, dynamic> toJson() => _$MoodToJson(this);
}

