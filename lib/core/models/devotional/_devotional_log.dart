import 'package:json_annotation/json_annotation.dart';

import '_devotional_log_content.dart';

part '_devotional_log.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLog {
  final int? id;
  final int? userId;
  final DevotionalLogContent? devotional;
  final bool? isFavorite;
  final bool? isCompleted;
  final String? note;
  @JsonKey(name: 'completedAt')
  final DateTime? completedAt;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  DevotionalLog({
    this.id,
    this.userId,
    this.devotional,
    this.isFavorite,
    this.isCompleted,
    this.note,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DevotionalLog.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogToJson(this);
}

