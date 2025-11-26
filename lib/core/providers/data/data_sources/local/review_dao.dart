import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final reviewDaoProvider = Provider<ReviewDao>((ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return ReviewDaoImpl(secureStorage: secureStorage);
});

abstract class ReviewDao {
  Future<DateTime?> getAppInstallationDate();
  Future<void> saveAppInstallationDate(DateTime date);
  Future<DateTime?> getLastReviewPromptDate();
  Future<void> saveLastReviewPromptDate(DateTime date);
  Future<bool> getReviewNeverAsk();
  Future<void> setReviewNeverAsk(bool value);
  Future<bool> getReviewedInOnboarding();
  Future<void> setReviewedInOnboarding(bool value);
  Future<bool> shouldShowReviewPrompt();
}

class ReviewDaoImpl implements ReviewDao {
  final SecureStorage secureStorage;

  ReviewDaoImpl({required this.secureStorage});

  @override
  Future<DateTime?> getAppInstallationDate() async {
    final dateString = await secureStorage.getValue(
      key: Constant.appInstallationDateKey,
    );
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveAppInstallationDate(DateTime date) async {
    await secureStorage.saveValue(
      key: Constant.appInstallationDateKey,
      value: date.toIso8601String(),
    );
  }

  @override
  Future<DateTime?> getLastReviewPromptDate() async {
    final dateString = await secureStorage.getValue(
      key: Constant.lastReviewPromptDateKey,
    );
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastReviewPromptDate(DateTime date) async {
    await secureStorage.saveValue(
      key: Constant.lastReviewPromptDateKey,
      value: date.toIso8601String(),
    );
  }

  @override
  Future<bool> getReviewNeverAsk() async {
    final value = await secureStorage.getValue(
      key: Constant.reviewNeverAskKey,
    );
    return value == 'true';
  }

  @override
  Future<void> setReviewNeverAsk(bool value) async {
    await secureStorage.saveValue(
      key: Constant.reviewNeverAskKey,
      value: value.toString(),
    );
  }

  @override
  Future<bool> getReviewedInOnboarding() async {
    final value = await secureStorage.getValue(
      key: Constant.reviewedInOnboardingKey,
    );
    return value == 'true';
  }

  @override
  Future<void> setReviewedInOnboarding(bool value) async {
    await secureStorage.saveValue(
      key: Constant.reviewedInOnboardingKey,
      value: value.toString(),
    );
  }

  @override
  Future<bool> shouldShowReviewPrompt() async {
    final neverAsk = await getReviewNeverAsk();
    if (neverAsk) return false;

    final reviewedInOnboarding = await getReviewedInOnboarding();
    if (reviewedInOnboarding) return false;

    final now = DateTime.now();
    final installationDate = await getAppInstallationDate();
    final lastPromptDate = await getLastReviewPromptDate();

    DateTime effectiveInstallationDate;
    if (installationDate == null) {
      effectiveInstallationDate = now;
      await saveAppInstallationDate(now);
      return false;
    } else {
      effectiveInstallationDate = installationDate;
    }

    if (lastPromptDate == null) {
      final daysSinceInstall = now.difference(effectiveInstallationDate).inDays;
      return daysSinceInstall >= 3;
    }

    final daysSinceLastPrompt = now.difference(lastPromptDate).inDays;
    final daysSinceInstall = now.difference(effectiveInstallationDate).inDays;
    
    if (daysSinceInstall < 10) {
      return daysSinceLastPrompt >= 7;
    } else if (daysSinceInstall < 25) {
      return daysSinceLastPrompt >= 15;
    } else {
      return daysSinceLastPrompt >= 15;
    }
  }
}

