import 'package:json_annotation/json_annotation.dart';

part '_mood_tag.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodTag {
  final String? name;

  MoodTag({
    this.name,
  });

  factory MoodTag.fromJson(Map<String, dynamic> json) =>
      _$MoodTagFromJson(json);

  Map<String, dynamic> toJson() => _$MoodTagToJson(this);
}

