import 'package:json_annotation/json_annotation.dart';

part '_devotional_log_request.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogRequest {
  final int devotionalId;
  final bool isFavorite;
  final bool isCompleted;
  final String? note;

  DevotionalLogRequest({
    required this.devotionalId,
    required this.isFavorite,
    required this.isCompleted,
    this.note,
  });

  factory DevotionalLogRequest.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogRequestToJson(this);
}

