import 'package:flutter/material.dart';

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        content: Text(message, style: textStyle ?? theme.textTheme.bodyLarge),
        behavior: behavior,
        duration: duration,
      ),
    );
  }
}
