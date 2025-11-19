import 'package:json_annotation/json_annotation.dart';

part '_devotional_category.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalCategory {
  final int? id;
  final String? key;
  final String? title;
  final String? description;
  final String? coverImage;
  final String? iconEmoji;
  final bool? isPremium;
  final bool? isActive;
  final int? order;

  DevotionalCategory({
    this.id,
    this.key,
    this.title,
    this.description,
    this.coverImage,
    this.iconEmoji,
    this.isPremium,
    this.isActive,
    this.order,
  });

  factory DevotionalCategory.fromJson(Map<String, dynamic> json) =>
      _$DevotionalCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalCategoryToJson(this);
}

