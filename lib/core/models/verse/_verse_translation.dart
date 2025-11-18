import 'package:json_annotation/json_annotation.dart';

part '_verse_translation.g.dart';

@JsonSerializable(includeIfNull: false)
class VerseTranslation {
  final String? lang;
  final String? ref;
  final String? text;

  VerseTranslation({
    this.lang,
    this.ref,
    this.text,
  });

  factory VerseTranslation.fromJson(Map<String, dynamic> json) =>
      _$VerseTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$VerseTranslationToJson(this);
}
