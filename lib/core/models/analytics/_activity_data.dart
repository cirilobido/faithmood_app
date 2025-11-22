import 'package:json_annotation/json_annotation.dart';

part '_activity_data.g.dart';

@JsonSerializable(includeIfNull: false)
class ActivityData {
  final bool? mood;
  final bool? devotional;

  ActivityData({
    this.mood,
    this.devotional,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) =>
      _$ActivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityDataToJson(this);
}

