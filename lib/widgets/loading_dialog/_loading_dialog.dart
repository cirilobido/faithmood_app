import 'package:flutter/material.dart' hide AnimatedContainer;

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../widgets_exports.dart';

class LoadingDialog {
  static void show({
    required BuildContext context,
    String? message,
  }) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final imageSize = screenWidth * 0.4;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  mode: AnimationMode.floating,
                  duration: const Duration(seconds: 2),
                  floatRange: 6,
                  child: Image.asset(
                    AppIcons.happyPetImage,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  message ?? lang.saving,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spacingMedium),
                const LoadingIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

