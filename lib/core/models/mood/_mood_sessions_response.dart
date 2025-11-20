import 'package:json_annotation/json_annotation.dart';

import '_mood_session.dart';

part '_mood_sessions_response.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSessionsResponse {
  final int? total;
  @JsonKey(fromJson: _parseInt, toJson: _stringify)
  final int? page;
  @JsonKey(fromJson: _parseInt, toJson: _stringify)
  final int? limit;
  final int? totalPages;
  final String? sortBy;
  final String? order;
  final List<MoodSession>? sessions;

  MoodSessionsResponse({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.sortBy,
    this.order,
    this.sessions,
  });

  factory MoodSessionsResponse.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionsResponseToJson(this);

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _stringify(int? value) {
    return value?.toString();
  }
}

