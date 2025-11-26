import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/core_exports.dart';
import '../../data/repository/review_repository_impl.dart';
import '../repository/review_repository.dart';

final reviewUseCaseProvider = Provider<ReviewUseCase>(
  (ref) => ReviewUseCase(ref.watch(reviewRepositoryProvider)),
);

class ReviewUseCase extends FutureUseCase<dynamic, dynamic> {
  final ReviewRepository repository;

  ReviewUseCase(this.repository);

  Future<Result<DateTime?, Exception>> getAppInstallationDate() async {
    try {
      final result = await repository.getAppInstallationDate();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> saveAppInstallationDate(DateTime date) async {
    try {
      await repository.saveAppInstallationDate(date);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<DateTime?, Exception>> getLastReviewPromptDate() async {
    try {
      final result = await repository.getLastReviewPromptDate();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> saveLastReviewPromptDate(DateTime date) async {
    try {
      await repository.saveLastReviewPromptDate(date);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool, Exception>> getReviewNeverAsk() async {
    try {
      final result = await repository.getReviewNeverAsk();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> setReviewNeverAsk(bool value) async {
    try {
      await repository.setReviewNeverAsk(value);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool, Exception>> getReviewedInOnboarding() async {
    try {
      final result = await repository.getReviewedInOnboarding();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> setReviewedInOnboarding(bool value) async {
    try {
      await repository.setReviewedInOnboarding(value);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool, Exception>> shouldShowReviewPrompt() async {
    try {
      final result = await repository.shouldShowReviewPrompt();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<DateTime?, Exception>> getLastPremiumPromptDate() async {
    try {
      final result = await repository.getLastPremiumPromptDate();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> saveLastPremiumPromptDate(DateTime date) async {
    try {
      await repository.saveLastPremiumPromptDate(date);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool, Exception>> shouldShowPremiumPrompt() async {
    try {
      final result = await repository.shouldShowPremiumPrompt();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<String?, Exception>> getLastPremiumModalType() async {
    try {
      final result = await repository.getLastPremiumModalType();
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> saveLastPremiumModalType(String type) async {
    try {
      await repository.saveLastPremiumModalType(type);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<String, Exception>> getPremiumModalTypeToShow() async {
    try {
      final result = await repository.getPremiumModalTypeToShow();
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

