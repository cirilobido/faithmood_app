import 'package:json_annotation/json_annotation.dart';

import '../shared/_paginated_response.dart';
import '_mood_session.dart';

part '_mood_sessions_response.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSessionsResponse extends PaginatedResponse {
  @JsonKey(name: 'sessions')
  final List<MoodSession>? sessions;
  @JsonKey(fromJson: PaginatedResponse.parseInt, toJson: PaginatedResponse.stringify)
  final int? page;
  @JsonKey(fromJson: PaginatedResponse.parseInt, toJson: PaginatedResponse.stringify)
  final int? limit;

  MoodSessionsResponse({
    super.total,
    this.page,
    this.limit,
    super.totalPages,
    super.sortBy,
    super.order,
    this.sessions,
  }) : super(page: page, limit: limit);

  factory MoodSessionsResponse.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionsResponseToJson(this);
}

