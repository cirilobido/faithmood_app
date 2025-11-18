import 'package:json_annotation/json_annotation.dart';

part '_devotional_category.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalCategory {
  final int? id;
  final String? key;
  final String? title;

  DevotionalCategory({
    this.id,
    this.key,
    this.title,
  });

  factory DevotionalCategory.fromJson(Map<String, dynamic> json) =>
      _$DevotionalCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalCategoryToJson(this);
}

