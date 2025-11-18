import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/verse_repository_impl.dart';
import '../repository/verse_repository.dart';

final verseUseCaseProvider = Provider<VerseUseCase>(
  (ref) => VerseUseCase(ref.watch(verseRepositoryProvider)),
);

class VerseUseCase extends FutureUseCase<dynamic, dynamic> {
  final VerseRepository repository;

  VerseUseCase(this.repository);

  Future<Result<Verse?, Exception>> getDailyVerse(String lang) async {
    try {
      final result = await repository.getDailyVerse(lang);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<dynamic, Exception>> run(params) {
    throw UnimplementedError();
  }
}
