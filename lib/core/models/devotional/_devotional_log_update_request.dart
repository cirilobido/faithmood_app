import 'package:json_annotation/json_annotation.dart';

part '_devotional_log_update_request.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogUpdateRequest {
  final String? note;

  DevotionalLogUpdateRequest({
    this.note,
  });

  factory DevotionalLogUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogUpdateRequestToJson(this);
}

