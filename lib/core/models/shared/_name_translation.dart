import 'package:json_annotation/json_annotation.dart';

part '_name_translation.g.dart';

@JsonSerializable(includeIfNull: false)
class NameTranslation {
  final String? name;

  NameTranslation({this.name});

  factory NameTranslation.fromJson(Map<String, dynamic> json) =>
      _$NameTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$NameTranslationToJson(this);
}

