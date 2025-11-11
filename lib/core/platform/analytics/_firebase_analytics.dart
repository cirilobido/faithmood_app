import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final firebaseAnalyticProvider =
    ChangeNotifierProvider<FirebaseAnalyticProvider>((ref) {
      return FirebaseAnalyticProvider();
    });

class FirebaseAnalyticProvider extends ChangeNotifier {
  FirebaseAnalytics? _analytics;

  FirebaseAnalyticProvider() {
    init();
  }

  Future<void> init() async {
    _analytics = FirebaseAnalytics.instance;
  }

  void logEvent({
    required String name,
    required Map<String, Object> parameters,
  }) async {
    if (_analytics == null) return;

    final newParameters = {...parameters};
    newParameters['env'] = kDebugMode ? 'debug' : 'release';
    newParameters['platform'] = Platform.isAndroid ? 'android' : 'ios';

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    newParameters['version'] = packageInfo.version;

    _analytics?.logEvent(name: name, parameters: newParameters);
  }
}
