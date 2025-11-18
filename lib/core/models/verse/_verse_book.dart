import 'package:json_annotation/json_annotation.dart';

part '_verse_book.g.dart';

@JsonSerializable(includeIfNull: false)
class VerseBook {
  final String? key;
  final String? name;
  final int? chapter;
  final int? verseNumber;

  VerseBook({
    this.key,
    this.name,
    this.chapter,
    this.verseNumber,
  });

  factory VerseBook.fromJson(Map<String, dynamic> json) =>
      _$VerseBookFromJson(json);

  Map<String, dynamic> toJson() => _$VerseBookToJson(this);
}
