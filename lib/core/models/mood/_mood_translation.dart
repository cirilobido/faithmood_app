import 'package:json_annotation/json_annotation.dart';

part '_mood_translation.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodTranslation {
  final String? name;

  MoodTranslation({
    this.name,
  });

  factory MoodTranslation.fromJson(Map<String, dynamic> json) =>
      _$MoodTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$MoodTranslationToJson(this);
}

