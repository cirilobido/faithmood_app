import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '../../features/home/_home_view_model.dart';
import '../../features/profile/_profile_view_model.dart';
import '../../features/devotionals/categories/_categories_view_model.dart';
import '../../features/journal/_journal_view_model.dart';
import '_settings_state.dart';

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  return SettingsViewModel(
    ref,
    ref.read(firebaseAnalyticProvider),
    ref.read(authProvider),
    ref.read(settingsProvider),
    ref.read(appLanguageProvider),
  );
});

class SettingsViewModel extends StateNotifier<SettingsState> {
  final Ref ref;
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;
  final AppLanguageProvider appLanguageProvider;

  SettingsViewModel(
    this.ref,
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.settingsProvider,
    this.appLanguageProvider,
  ) : super(SettingsState());

  Settings? get settings => settingsProvider.settings;

  void updateState({
    bool? isPremium,
    String? appVersion,
    bool? isLoading,
    bool? error,
  }) {
    state = state.copyWith(
      isPremium: isPremium,
      appVersion: appVersion,
      isLoading: isLoading,
      error: error,
    );
  }

  Future<void> loadData() async {
    updateState(isLoading: true, error: false);
    try {
      final user = authProvider.user;
      final isPremium = user?.planType != PlanName.FREE;
      
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;

      updateState(
        isPremium: isPremium,
        appVersion: appVersion,
        isLoading: false,
      );

      firebaseAnalyticProvider.logEvent(
        name: 'settings_screen_loaded',
        parameters: {'screen': 'settings_screen'},
      );
    } catch (e) {
      updateState(isLoading: false, error: true);
      firebaseAnalyticProvider.logEvent(
        name: 'settings_screen_load_failed',
        parameters: {'screen': 'settings_screen', 'error': e.toString()},
      );
    }
  }

  Future<bool> logOut() async {
    try {
      firebaseAnalyticProvider.logEvent(
        name: 'user_logout_attempt',
        parameters: {'screen': 'settings_screen'},
      );

      await authProvider.signOut();
      
      // Log out from Purchases, handle anonymous user gracefully
      try {
        await Purchases.logOut();
      } catch (e) {
        devLogger('⚠️ Purchases logOut failed (user may be anonymous): $e');
        // Continue even if Purchases logout fails
      }

      firebaseAnalyticProvider.logEvent(
        name: 'user_logout_success',
        parameters: {'screen': 'settings_screen'},
      );

      return true;
    } catch (e) {
      firebaseAnalyticProvider.logEvent(
        name: 'user_logout_failed',
        parameters: {'screen': 'settings_screen', 'error': e.toString()},
      );
      return false;
    }
  }

  Future<void> rateApp() async {
    try {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        firebaseAnalyticProvider.logEvent(
          name: 'request_review',
          parameters: {'screen': 'settings_screen'},
        );
        await inAppReview.requestReview();
      } else {
        firebaseAnalyticProvider.logEvent(
          name: 'open_store_listing_review',
          parameters: {'screen': 'settings_screen'},
        );
        await inAppReview.openStoreListing();
      }
    } catch (e) {
      devLogger('Rate app failed: $e');
      firebaseAnalyticProvider.logEvent(
        name: 'error_request_review',
        parameters: {'screen': 'settings_screen', 'error': e.toString()},
      );
    }
  }

  Future<void> launchAppUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        firebaseAnalyticProvider.logEvent(
          name: 'launch_external_url',
          parameters: {'screen': 'settings_screen', 'url': url},
        );
      }
    } catch (e) {
      devLogger('Launch URL failed: $e');
      firebaseAnalyticProvider.logEvent(
        name: 'error_launch_url',
        parameters: {'screen': 'settings_screen', 'error': e.toString()},
      );
    }
  }

  Future<void> handleLanguageChange(Lang newLang) async {
    try {
      final currentUser = authProvider.user;
      final currentLang = currentUser?.lang;
      final hasLanguageChanged = currentLang != newLang;

      if (hasLanguageChanged) {
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(lang: newLang);
          await authProvider.updateUserData(updatedUser);
        }

        _refreshLanguageDependentData();

        firebaseAnalyticProvider.logEvent(
          name: 'language_changed',
          parameters: {
            'screen': 'settings_screen',
            'old_lang': currentLang?.name ?? 'unknown',
            'new_lang': newLang.name,
            'user_logged_in': currentUser != null ? 'true' : 'false',
          },
        );
      }
    } catch (e) {
      devLogger('Error changing language: $e');
      firebaseAnalyticProvider.logEvent(
        name: 'language_change_failed',
        parameters: {'screen': 'settings_screen', 'error': e.toString()},
      );
    }
  }

  void _refreshLanguageDependentData() {
    try {
      ref.invalidate(categoriesViewModelProvider);
      
      final homeViewModel = ref.read(homeViewModelProvider.notifier);
      homeViewModel.refreshDailyVerse();
      homeViewModel.refreshMoods();
      
      final profileViewModel = ref.read(profileViewModelProvider.notifier);
      profileViewModel.loadMoods();
      final profileState = ref.read(profileViewModelProvider);
      if (profileState.thisWeekStats != null) {
        profileViewModel.getAnalytics(AnalyticsPeriod.thisWeek, forceRefresh: true);
      }
      if (profileState.thisMonthStats != null) {
        profileViewModel.getAnalytics(AnalyticsPeriod.thisMonth, forceRefresh: true);
      }
      if (profileState.lastWeekStats != null) {
        profileViewModel.getAnalytics(AnalyticsPeriod.lastWeek, forceRefresh: true);
      }
      if (profileState.lastMonthStats != null) {
        profileViewModel.getAnalytics(AnalyticsPeriod.lastMonth, forceRefresh: true);
      }
      
      final journalViewModel = ref.read(journalViewModelProvider.notifier);
      journalViewModel.refreshMoods();
      journalViewModel.refreshMoodSessions();
      journalViewModel.refreshDevotionalLogs();
    } catch (e) {
      devLogger('Error refreshing language-dependent data: $e');
    }
  }
}

