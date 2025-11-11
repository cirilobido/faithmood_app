import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:url_strategy/url_strategy.dart';

import 'core/core_exports.dart';
import 'dev_utils/_logger.dart';
import 'routes/app_routes.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  /*NATIVE SPLASH RELATED*/
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  /*TIMEZONE RELATED*/
  tzdata.initializeTimeZones();
  final TimezoneInfo timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName.identifier));

  /*FIREBASE RELATED*/
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notifications = LocalNotificationsService.instance();
  await notifications.init();
  try {
    await notifications.restoreDailyNotification();
  } catch (e) {
    devLogger(e.toString());
  }
  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: notifications);

  /*GOOGLE ADS RELATED*/
  RequestConfiguration requestConfiguration = RequestConfiguration();
  if (kDebugMode) {
    requestConfiguration = RequestConfiguration(
      // TODO: For testing purposes only
      // testDeviceIds: ['4F0049DA39CCE71E36C811DE510D1997'],
    );
  }

  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  await MobileAds.instance.initialize();

  runApp(const ProviderScope(child: FaithMoodApp()));
}

class FaithMoodApp extends ConsumerStatefulWidget {
  const FaithMoodApp({super.key});

  @override
  ConsumerState<FaithMoodApp> createState() => _AppState();
}

class _AppState extends ConsumerState<FaithMoodApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /*NATIVE SPLASH RELATED*/
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final appLang = ref.watch(appLanguageProvider);

    return MaterialApp.router(
      title: 'FaithMood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme(),
      darkTheme: AppTheme.appTheme(),
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
