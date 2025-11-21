import 'package:faithmood_app/core/core_exports.dart';
import 'package:json_annotation/json_annotation.dart';

part '_tag.g.dart';

@JsonSerializable(includeIfNull: false)
class Tag {
  final int? id;
  final String? key;
  final String? name;
  final String? color;
  final String? icon;
  final bool? isActive;
  final List<NameTranslation>? translations;

  Tag({
    this.id,
    this.key,
    this.name,
    this.color,
    this.icon,
    this.isActive,
    this.translations,
  });

  factory Tag.fromJson(Map<String, dynamic> json) =>
      _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

