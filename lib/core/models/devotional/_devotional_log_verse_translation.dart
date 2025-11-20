import 'package:json_annotation/json_annotation.dart';

part '_devotional_log_verse_translation.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogVerseTranslation {
  final int? id;
  final int? verseId;
  final String? lang;
  final String? ref;
  final String? text;

  DevotionalLogVerseTranslation({
    this.id,
    this.verseId,
    this.lang,
    this.ref,
    this.text,
  });

  factory DevotionalLogVerseTranslation.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogVerseTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogVerseTranslationToJson(this);
}

