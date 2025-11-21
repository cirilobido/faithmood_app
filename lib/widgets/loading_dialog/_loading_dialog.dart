import 'package:flutter/material.dart';

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
                const LoadingIndicator(),
                const SizedBox(height: AppSizes.spacingMedium),
                Text(
                  message ?? lang.saving,
                  style: theme.textTheme.bodyLarge,
                ),
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

