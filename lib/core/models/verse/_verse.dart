import 'package:json_annotation/json_annotation.dart';

import '_verse_book.dart';

part '_verse.g.dart';

@JsonSerializable(includeIfNull: false)
class Verse {
  final int? id;
  final String? ref;
  final String? text;
  final String? lang;
  final VerseBook? book;
  final DateTime? createdAt;

  Verse({
    this.id,
    this.ref,
    this.text,
    this.lang,
    this.book,
    this.createdAt,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);

  Map<String, dynamic> toJson() => _$VerseToJson(this);

  /// Formats the verse reference as "Book Name Chapter:Verse"
  /// Example: "Hebrews 11:1"
  String getFormattedRef() {
    if (book?.name != null && book?.chapter != null && book?.verseNumber != null) {
      return '${book!.name} ${book!.chapter}:${book!.verseNumber}';
    }
    // Fallback to ref if book info is not available
    return ref ?? '';
  }
}
