import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '_settings_state.dart';

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  return SettingsViewModel(
    ref.read(firebaseAnalyticProvider),
    ref.read(authProvider),
    ref.read(settingsProvider),
    ref.read(appLanguageProvider),
  );
});

class SettingsViewModel extends StateNotifier<SettingsState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;
  final AppLanguageProvider appLanguageProvider;

  SettingsViewModel(
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
      devLogger(e.toString());
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
      devLogger(e.toString());
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
}

