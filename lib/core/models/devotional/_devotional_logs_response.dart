import 'package:json_annotation/json_annotation.dart';

import '_devotional_log.dart';

part '_devotional_logs_response.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogsResponse {
  final int? total;
  @JsonKey(fromJson: _parseInt, toJson: _stringify)
  final int? page;
  @JsonKey(fromJson: _parseInt, toJson: _stringify)
  final int? limit;
  final int? totalPages;
  final String? sortBy;
  final String? order;
  final List<DevotionalLog>? logs;
  final String? message;

  DevotionalLogsResponse({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.sortBy,
    this.order,
    this.logs,
    this.message,
  });

  factory DevotionalLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogsResponseToJson(this);

  static int? _parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value);
    }
    return value as int?;
  }

  static String? _stringify(int? value) {
    return value?.toString();
  }
}

