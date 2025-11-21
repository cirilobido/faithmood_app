import 'package:json_annotation/json_annotation.dart';

import '../shared/_paginated_response.dart';
import '_devotional_log.dart';

part '_devotional_logs_response.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogsResponse extends PaginatedResponse {
  @JsonKey(name: 'logs')
  final List<DevotionalLog>? logs;
  @JsonKey(fromJson: PaginatedResponse.parseInt, toJson: PaginatedResponse.stringify)
  final int? page;
  @JsonKey(fromJson: PaginatedResponse.parseInt, toJson: PaginatedResponse.stringify)
  final int? limit;

  DevotionalLogsResponse({
    super.total,
    this.page,
    this.limit,
    super.totalPages,
    super.sortBy,
    super.order,
    this.logs,
    super.message,
  }) : super(page: page, limit: limit);

  factory DevotionalLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogsResponseToJson(this);
}

