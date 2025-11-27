import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:selah_app/core/core_exports.dart';

Future<void> triggerHapticFeedback(
  HapticsType type, {
  BuildContext? context,
}) async {
  // Check if haptic feedback is enabled via provider
  bool isEnabled = true; // Default to enabled if context not available
  if (context != null) {
    try {
      final container = ProviderScope.containerOf(context);
      final hapticProvider = container.read(hapticFeedbackProvider);
      isEnabled = hapticProvider.isEnabled;
    } catch (e) {
      // If we can't access the provider, default to enabled
      isEnabled = true;
    }
  }
  
  if (!isEnabled) return;
  
  try {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(type, usage: HapticsUsage.touch);
    }
  } catch (e) {
    // Silently fail if haptic feedback is not available
  }
}
