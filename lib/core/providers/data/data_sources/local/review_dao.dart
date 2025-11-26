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
  Future<DateTime?> getLastPremiumPromptDate();
  Future<void> saveLastPremiumPromptDate(DateTime date);
  Future<bool> shouldShowPremiumPrompt();
  Future<String?> getLastPremiumModalType();
  Future<void> saveLastPremiumModalType(String type);
  Future<String> getPremiumModalTypeToShow();
  Future<bool> getPremiumBannerDismissed();
  Future<void> setPremiumBannerDismissed(bool value);
}

class ReviewDaoImpl implements ReviewDao {
  final SecureStorage secureStorage;

  ReviewDaoImpl({required this.secureStorage});

  @override
  Future<DateTime?> getAppInstallationDate() async {
    try {
      final dateString = await secureStorage.getValue(
        key: Constant.appInstallationDateKey,
      );
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveAppInstallationDate(DateTime date) async {
    try {
      await secureStorage.saveValue(
        key: Constant.appInstallationDateKey,
        value: date.toIso8601String(),
      );
    } catch (_) {
      // Silently fail - not critical for app functionality
    }
  }

  @override
  Future<DateTime?> getLastReviewPromptDate() async {
    try {
      final dateString = await secureStorage.getValue(
        key: Constant.lastReviewPromptDateKey,
      );
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastReviewPromptDate(DateTime date) async {
    try {
      await secureStorage.saveValue(
        key: Constant.lastReviewPromptDateKey,
        value: date.toIso8601String(),
      );
    } catch (_) {
      // Silently fail - not critical for app functionality
    }
  }

  @override
  Future<bool> getReviewNeverAsk() async {
    try {
      final value = await secureStorage.getValue(
        key: Constant.reviewNeverAskKey,
      );
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setReviewNeverAsk(bool value) async {
    try {
      await secureStorage.saveValue(
        key: Constant.reviewNeverAskKey,
        value: value.toString(),
      );
    } catch (_) {
      // Silently fail - not critical for app functionality
    }
  }

  @override
  Future<bool> getReviewedInOnboarding() async {
    try {
      final value = await secureStorage.getValue(
        key: Constant.reviewedInOnboardingKey,
      );
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setReviewedInOnboarding(bool value) async {
    try {
      await secureStorage.saveValue(
        key: Constant.reviewedInOnboardingKey,
        value: value.toString(),
      );
    } catch (_) {
      // Silently fail - not critical for app functionality
    }
  }

  @override
  Future<bool> shouldShowReviewPrompt() async {
    try {
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
    } catch (_) {
      return false;
    }
  }

  @override
  Future<DateTime?> getLastPremiumPromptDate() async {
    try {
      final dateString = await secureStorage.getValue(
        key: Constant.lastPremiumPromptDateKey,
      );
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastPremiumPromptDate(DateTime date) async {
    try {
      await secureStorage.saveValue(
        key: Constant.lastPremiumPromptDateKey,
        value: date.toIso8601String(),
      );
    } catch (_) {
      // Silently fail - not critical for app functionality
    }
  }

  @override
  Future<bool> shouldShowPremiumPrompt() async {
    try {
      final now = DateTime.now();
      final installationDate = await getAppInstallationDate();
      final lastPromptDate = await getLastPremiumPromptDate();

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
        return daysSinceInstall >= 1;
      }

      final daysSinceLastPrompt = now.difference(lastPromptDate).inDays;
      final daysSinceInstall = now.difference(effectiveInstallationDate).inDays;
      
      if (daysSinceInstall < 6) {
        return daysSinceLastPrompt >= 5;
      } else if (daysSinceInstall < 16) {
        return daysSinceLastPrompt >= 10;
      } else {
        return daysSinceLastPrompt >= 10;
      }
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> getLastPremiumModalType() async {
    try {
      return await secureStorage.getValue(
        key: Constant.lastPremiumModalTypeKey,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLastPremiumModalType(String type) async {
    try {
      await secureStorage.saveValue(
        key: Constant.lastPremiumModalTypeKey,
        value: type,
      );
    } catch (_) {
      // Silently fail - not critical for app functionality
    }
  }

  @override
  Future<String> getPremiumModalTypeToShow() async {
    try {
      final lastType = await getLastPremiumModalType();
      if (lastType == null || lastType == 'simple') {
        return 'detailed';
      } else {
        return 'simple';
      }
    } catch (_) {
      return 'simple';
    }
  }

  @override
  Future<bool> getPremiumBannerDismissed() async {
    try {
      final value = await secureStorage.getValue(
        key: Constant.premiumBannerDismissedKey,
      );
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setPremiumBannerDismissed(bool value) async {
    try {
      await secureStorage.saveValue(
        key: Constant.premiumBannerDismissedKey,
        value: value.toString(),
      );
    } catch (_) {
      // Silently fail - not critical for app functionality
    }
  }
}

