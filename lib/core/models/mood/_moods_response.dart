import 'package:json_annotation/json_annotation.dart';

import '_mood.dart';

part '_moods_response.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodsResponse {
  final List<Mood>? moods;
  final String? message;

  MoodsResponse({
    this.moods,
    this.message,
  });

  factory MoodsResponse.fromJson(Map<String, dynamic> json) =>
      _$MoodsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoodsResponseToJson(this);
}

