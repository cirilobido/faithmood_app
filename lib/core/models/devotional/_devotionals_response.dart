import 'package:json_annotation/json_annotation.dart';

import '_devotional.dart';

part '_devotionals_response.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalsResponse {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;
  final List<Devotional>? results;

  DevotionalsResponse({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.results,
  });

  factory DevotionalsResponse.fromJson(Map<String, dynamic> json) =>
      _$DevotionalsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalsResponseToJson(this);
}

