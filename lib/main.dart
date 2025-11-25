import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:url_strategy/url_strategy.dart';

import 'core/core_exports.dart';
import 'dev_utils/_logger.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'generated/l10n.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  // Global error handling
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    devLogger('🔥 Flutter Error: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    devLogger('🔥 Unhandled platform error: $error\n$stack');
    return true;
  };

  // Run inside a guarded zone to catch any top-level async errors
  await runZonedGuarded<Future<void>>(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();

      // Keep native splash visible during initialization
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      await _initializeCore();

      FlutterNativeSplash.remove();

      runApp(const ProviderScope(child: FaithMoodApp()));
    },
    (error, stack) {
      devLogger('🔥 Uncaught Zone Error: $error\n$stack');
    },
  );
}

Future<void> _initializeCore() async {
  // URL strategy
  setPathUrlStrategy();

  // Timezone setup
  try {
    tzdata.initializeTimeZones();
    final TimezoneInfo timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName.identifier));
  } catch (e, s) {
    devLogger('⚠️ Timezone initialization failed: $e\n$s');
  }

  // Firebase setup
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final notifications = LocalNotificationsService.instance();
    await notifications.init();

    try {
      await notifications.restoreDailyNotification();
    } catch (e, s) {
      devLogger('⚠️ Failed to restore daily notification: $e\n$s');
    }

    final firebaseMessagingService = FirebaseMessagingService.instance();
    await firebaseMessagingService.init(
      localNotificationsService: notifications,
    );
  } catch (e, s) {
    devLogger('⚠️ Firebase or Notifications initialization failed: $e\n$s');
  }

  try {
    await initializeRevenueCat();
  } catch (e, s) {
    devLogger('⚠️ RevenueCat initialization failed: $e\n$s');
    devLogger(e.toString());
  }

  // Google Ads setup
  try {
    RequestConfiguration requestConfiguration = RequestConfiguration();
    if (kDebugMode) {
      requestConfiguration = RequestConfiguration(
        // For testing only
        testDeviceIds: ['4F0049DA39CCE71E36C811DE510D1997'],
      );
    }

    MobileAds.instance.updateRequestConfiguration(requestConfiguration);

    await MobileAds.instance.initialize().timeout(
      const Duration(seconds: 6),
      onTimeout: () {
        devLogger('⚠️ Google Ads initialization timeout');
        return InitializationStatus({});
      },
    );
  } catch (e, s) {
    devLogger('⚠️ Google Ads initialization failed: $e\n$s');
  }
}

Future<void> initializeRevenueCat({String? appUserId}) async {
  PurchasesConfiguration? configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration('TEST_KEY')
      ..shouldShowInAppMessagesAutomatically = false
      ..appUserID = appUserId;
  }
  if (configuration != null) {
    await Purchases.configure(configuration);
  }
}

class FaithMoodApp extends ConsumerStatefulWidget {
  const FaithMoodApp({super.key});

  @override
  ConsumerState<FaithMoodApp> createState() => _AppState();
}

class _AppState extends ConsumerState<FaithMoodApp> {
  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final appLang = ref.watch(appLanguageProvider);

    return MaterialApp.router(
      title: 'FaithMood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: appTheme.themeMode,
      locale: appLang.currentLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      routerConfig: AppRoutes.routerConfig,
    );
  }
}
