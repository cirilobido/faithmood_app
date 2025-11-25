import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import '../../core/core_exports.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    TextStyle? textStyle,
  }) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final isError = bgColor == theme.colorScheme.error;
    final isPrimary = bgColor == theme.colorScheme.primary;

    HapticsType hapticType;
    if (isError) {
      hapticType = HapticsType.error;
    } else if (isPrimary) {
      hapticType = HapticsType.success;
    } else {
      hapticType = HapticsType.warning;
    }

    triggerHapticFeedback(hapticType, context: context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        content: Text(message, style: textStyle ?? theme.textTheme.bodyLarge),
        behavior: behavior,
        duration: duration,
      ),
    );
  }
}
