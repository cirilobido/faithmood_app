abstract class PaginatedResponse {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;
  final String? sortBy;
  final String? order;
  final String? message;

  PaginatedResponse({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.sortBy,
    this.order,
    this.message,
  });

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _stringify(int? value) {
    return value?.toString();
  }

  static int? parseInt(dynamic value) => _parseInt(value);
  static String? stringify(int? value) => _stringify(value);
}

