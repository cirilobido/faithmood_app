import 'package:json_annotation/json_annotation.dart';

import '_devotional_category.dart';

part '_categories_response.g.dart';

@JsonSerializable(includeIfNull: false)
class CategoriesResponse {
  final List<DevotionalCategory>? categories;

  CategoriesResponse({
    this.categories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}

