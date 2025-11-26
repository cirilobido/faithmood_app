abstract class ReviewRepository {
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
}

