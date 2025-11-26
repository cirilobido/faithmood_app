import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/review_repository.dart';
import '../data_sources/local/review_dao.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(
    reviewDao: ref.watch(reviewDaoProvider),
  );
});

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewDao reviewDao;

  ReviewRepositoryImpl({required this.reviewDao});

  @override
  Future<DateTime?> getAppInstallationDate() async {
    return await reviewDao.getAppInstallationDate();
  }

  @override
  Future<void> saveAppInstallationDate(DateTime date) async {
    await reviewDao.saveAppInstallationDate(date);
  }

  @override
  Future<DateTime?> getLastReviewPromptDate() async {
    return await reviewDao.getLastReviewPromptDate();
  }

  @override
  Future<void> saveLastReviewPromptDate(DateTime date) async {
    await reviewDao.saveLastReviewPromptDate(date);
  }

  @override
  Future<bool> getReviewNeverAsk() async {
    return await reviewDao.getReviewNeverAsk();
  }

  @override
  Future<void> setReviewNeverAsk(bool value) async {
    await reviewDao.setReviewNeverAsk(value);
  }

  @override
  Future<bool> getReviewedInOnboarding() async {
    return await reviewDao.getReviewedInOnboarding();
  }

  @override
  Future<void> setReviewedInOnboarding(bool value) async {
    await reviewDao.setReviewedInOnboarding(value);
  }

  @override
  Future<bool> shouldShowReviewPrompt() async {
    return await reviewDao.shouldShowReviewPrompt();
  }

  @override
  Future<DateTime?> getLastPremiumPromptDate() async {
    return await reviewDao.getLastPremiumPromptDate();
  }

  @override
  Future<void> saveLastPremiumPromptDate(DateTime date) async {
    await reviewDao.saveLastPremiumPromptDate(date);
  }

  @override
  Future<bool> shouldShowPremiumPrompt() async {
    return await reviewDao.shouldShowPremiumPrompt();
  }

  @override
  Future<String?> getLastPremiumModalType() async {
    return await reviewDao.getLastPremiumModalType();
  }

  @override
  Future<void> saveLastPremiumModalType(String type) async {
    await reviewDao.saveLastPremiumModalType(type);
  }

  @override
  Future<String> getPremiumModalTypeToShow() async {
    return await reviewDao.getPremiumModalTypeToShow();
  }
}

