import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../platform/platform_exports.dart';

extension ContextExtension on BuildContext {
  Future<void> pushWithAnalytics(WidgetRef ref, String route, {Object? extra}) async {
    final analytics = ref.read(firebaseAnalyticProvider);
    analytics.logEvent(
      name: 'push_with_analytics',
      parameters: {'screen': route, 'extra': extra.toString()},
    );
    push(route, extra: extra);
  }

  Future<void> goWithAnalytics(WidgetRef ref, String route, {Object? extra}) async {
    final analytics = ref.read(firebaseAnalyticProvider);
    analytics.logEvent(
      name: 'go_with_analytics',
      parameters: {'screen': route, 'extra': extra.toString()},
    );
    go(route, extra: extra);
  }
}
