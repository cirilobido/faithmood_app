import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '../../generated/l10n.dart';
import '../../routes/app_routes_names.dart';
import '../../core/providers/domain/use_cases/review_use_case.dart';
import '_welcome_state.dart';

final welcomeViewModelProvider =
    AutoDisposeStateNotifierProvider<WelcomeViewModel, WelcomeState>((ref) {
      return WelcomeViewModel(
        ref.read(firebaseAnalyticProvider),
        ref.read(authProvider),
        ref.read(settingsProvider),
        ref.read(reviewUseCaseProvider),
      );
    });

class WelcomeViewModel extends StateNotifier<WelcomeState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;
  final ReviewUseCase reviewUseCase;

  WelcomeViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.settingsProvider,
    this.reviewUseCase,
  ) : super(WelcomeState()) {
    _initializeBackendPageOrder();
  }

  bool get isFirstTimeOpen => settingsProvider.isFirstTimeOpen;

  final nameController = TextEditingController();
  final nameFocus = FocusNode();

  final ageController = TextEditingController();
  final ageFocus = FocusNode();

  final langController = TextEditingController(
    text: Lang.toTitle(value: Lang.en) ?? '',
  );
  Lang selectedLang = Lang.en;

  final List<String> selectedExperience = [];
  String? selectedCommitted;
  String? selectedEverUsed;
  String? selectedGuidedPlan;
  String? selectedSocial;

  late List<int> backendPageOrder;
  bool _registrationAttempted = false;

  void _initializeBackendPageOrder() {
    final onboardingScreens = settingsProvider.settings?.onboardingScreens;
    if (onboardingScreens != null && onboardingScreens.isNotEmpty) {
      backendPageOrder = List<int>.from(onboardingScreens);
    } else {
      backendPageOrder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    }
  }

  void updateState({
    int? currentPage,
    double? progress,
    bool? isLoading,
    bool? error,
  }) {
    state = state.copyWith(
      currentPage: currentPage,
      progress: progress,
      isLoading: isLoading,
      error: error,
    );
  }

  Future<void> getIsFirstTimeOpen() async {
    try {
      await settingsProvider.getIsFirstTimeOpen();
    } catch (e) {
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
      devLogger(e.toString());
    }
  }

  Future<void> setIsFirstTimeOpenFalse() async {
    try {
      updateState(isLoading: true, error: false);
      await settingsProvider.setIsFirstTimeOpen(false);
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_false',
        parameters: {'screen': 'welcome_screen'},
      );
      updateState(isLoading: false);
    } catch (e) {
      updateState(isLoading: false, error: true);
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_false_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    }
  }

  Future<void> skipTapEvent() async {
    try {
      firebaseAnalyticProvider.logEvent(
        name: 'on_skip_tap_successfully',
        parameters: {'screen': 'welcome_screen'},
      );
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'on_skip_tap_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    }
  }

  int getCurrentBackendIndex() {
    final idx = state.currentPage;
    if (idx >= backendPageOrder.length) return 0;
    return backendPageOrder[idx];
  }

  void setBackendOrder(List<int> order) {
    backendPageOrder = order;
    _updateProgress();
  }

  bool nextPage() {
    final next = state.currentPage + 1;
    if (next >= backendPageOrder.length) return false;

    updateState(currentPage: next);
    _updateProgress();
    return true;
  }

  void previousPage() {
    final prev = state.currentPage - 1;
    if (prev < 0) return;

    updateState(currentPage: prev);
    _updateProgress();
  }

  void _updateProgress() {
    final total = backendPageOrder.length;
    if (total <= 0) return;

    final value = state.currentPage / total;
    final progress = value.clamp(0, 1).toDouble();
    updateState(progress: progress);
  }

  String? validatePage(int backendIndex, BuildContext context) {
    final lang = S.of(context);

    if (backendIndex == 1) {
      InputValidations.validateName(context, nameController.text.trim());
      if (ageController.text.trim().isEmpty ||
          int.parse(ageController.text) <= 0) {
        return lang.ageIsRequired;
      }
    }
    if (backendIndex == 2 && selectedExperience.isEmpty) {
      return lang.selectAnOption;
    }
    if (backendIndex == 3 && selectedCommitted == null) {
      return lang.selectAnOption;
    }
    if (backendIndex == 4 && selectedEverUsed == null) {
      return lang.selectAnOption;
    }
    if (backendIndex == 6 && selectedGuidedPlan == null) {
      return lang.selectAnOption;
    }
    if (backendIndex == 10 && selectedSocial == null) {
      return lang.selectAnOption;
    }
    // TODO: ADD PAYMENT
    return null;
  }

  Future<void> requestNotificationPermission() async {
    try {
      updateState(isLoading: true);
      await FirebaseMessagingService.instance().requestPermission();
      firebaseAnalyticProvider.logEvent(
        name: 'allow_notifications_tap',
        parameters: {'screen': 'welcome_screen'},
      );
    } catch (e, s) {
      devLogger('⚠️ Notification permission failed: $e\n$s');
      firebaseAnalyticProvider.logEvent(
        name: 'allow_notifications_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    } finally {
      updateState(isLoading: false);
      // Trigger registration after notification permission (fire and forget)
      if (!_registrationAttempted) {
        _registrationAttempted =
            true; // Set immediately to prevent double triggering
        registerUser().catchError((e) {
          devLogger('⚠️ Registration error (background): $e');
          return false;
        });
      }
    }
  }

  Future<bool> registerUser() async {
    try {
      // Validate name and age before registration
      if (nameController.text.trim().isEmpty) {
        devLogger('⚠️ Registration failed: Name is empty');
        return false;
      }
      if (ageController.text.trim().isEmpty) {
        devLogger('⚠️ Registration failed: Age is empty');
        return false;
      }

      final age = int.tryParse(ageController.text.trim());
      if (age == null || age <= 0) {
        devLogger('⚠️ Registration failed: Invalid age');
        return false;
      }

      updateState(isLoading: true, error: false);

      // Check if notifications are enabled
      bool notificationsEnabled = false;
      String? token;
      try {
        // Get FCM token
        final firebaseMessagingService = FirebaseMessagingService.instance();
        token = await firebaseMessagingService.getToken();
        notificationsEnabled = await firebaseMessagingService
            .areNotificationsEnabled();
      } catch (e) {
        devLogger('⚠️ Registration failed: $e');
        return false;
      }

      // Get timezone
      final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone();

      // Create AuthRequest with name, age, lang, fcmToken, timezone, and notificationsEnabled
      final params = AuthRequest(
        name: nameController.text.trim(),
        age: age,
        lang: selectedLang,
        fcmToken: token,
        timezone: timezone.identifier,
        notificationsEnabled: notificationsEnabled,
      );

      // Register user
      await authProvider.registerUser(params);

      final result = authProvider.user;

      if (result != null) {
        await getIsFirstTimeOpen();
        await setIsFirstTimeOpenFalse();

        // Log in to Purchases if user ID is available
        if (result.id != null) {
          try {
            await Purchases.logIn(result.id.toString());
          } catch (e) {
            devLogger('⚠️ Purchases logIn failed: $e');
            // Continue even if Purchases login fails
          }
        }

        updateState(isLoading: false);
        firebaseAnalyticProvider.logEvent(
          name: 'user_registration_successfully',
          parameters: {'screen': 'welcome_screen'},
        );
        _registrationAttempted = true;
        return true;
      }

      updateState(isLoading: false);
      return false;
    } catch (e) {
      updateState(isLoading: false, error: true);
      firebaseAnalyticProvider.logEvent(
        name: 'user_registration_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
      devLogger(e.toString());
      return false;
    }
  }

  Future<void> rateApp(BuildContext context) async {
    final backendIndex = getCurrentBackendIndex();
    _logNextSuccess(backendIndex);
    try {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        firebaseAnalyticProvider.logEvent(
          name: 'request_review',
          parameters: {'screen': 'welcome_screen'},
        );
        await inAppReview.requestReview();
      } else {
        firebaseAnalyticProvider.logEvent(
          name: 'open_store_listing_review',
          parameters: {'screen': 'welcome_screen'},
        );
        await inAppReview.openStoreListing();
      }
      final result = await reviewUseCase.setReviewedInOnboarding(true);
      switch (result) {
        case Success():
          break;
        case Failure(exception: final e):
          devLogger('⚠️ Error setting reviewed in onboarding: $e');
      }
    } catch (e, s) {
      devLogger('⚠️ Rate app failed: $e\n$s');
      firebaseAnalyticProvider.logEvent(
        name: 'error_request_review',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    } finally {
      await finishOnboarding(context, completedBackendIndex: backendIndex);
    }
  }

  Future<void> goToNextOrFinish(BuildContext context) async {
    final backendIndex = getCurrentBackendIndex();

    // Trigger registration at index 7 when user clicks "Maybe Later" (fire and forget)
    // Note: If user clicks "Allow", registration is triggered in requestNotificationPermission()
    if (backendIndex == 7 && !_registrationAttempted) {
      _registrationAttempted =
          true; // Set immediately to prevent double triggering
      registerUser().catchError((e) {
        devLogger('⚠️ Registration error (background): $e');
        return false;
      }); // Run without await so user can continue immediately
    }

    _logNextSuccess(backendIndex);
    final advanced = nextPage();
    if (!advanced) {
      await finishOnboarding(context, completedBackendIndex: backendIndex);
    }
  }

  Future<void> finishOnboarding(
    BuildContext context, {
    int? completedBackendIndex,
  }) async {
    final backendIndex = completedBackendIndex ?? getCurrentBackendIndex();
    _logOnboardingFinished(backendIndex);
    await setIsFirstTimeOpenFalse();
    if (!context.mounted) return;
    context.push(Routes.home);
  }

  void _logNextSuccess(int backendIndex) {
    firebaseAnalyticProvider.logEvent(
      name: 'welcome_next_success',
      parameters: {'screen': 'welcome_screen', 'backend_index': backendIndex},
    );
  }

  void _logOnboardingFinished(int backendIndex) {
    firebaseAnalyticProvider.logEvent(
      name: 'welcome_finish_onboarding',
      parameters: {
        'screen': 'welcome_screen',
        'last_backend_index': backendIndex,
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocus.dispose();
    ageController.dispose();
    ageFocus.dispose();
    langController.dispose();
    super.dispose();
  }
}
