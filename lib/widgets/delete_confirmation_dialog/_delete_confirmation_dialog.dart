import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../widgets_exports.dart';

class DeleteConfirmationDialog {
  static Future<bool?> show({
    required BuildContext context,
    String? title,
    String? message,
    String? iconPath,
  }) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text(
            title ?? lang.deleteMoodEntry,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          content: Text(
            message ?? lang.deleteMoodEntryMessage,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          icon: iconPath != null
              ? Image.asset(
                  iconPath,
                  height: AppSizes.dialogIconSize,
                )
              : null,
          actions: <Widget>[
            Column(
              children: [
                CustomButton(
                  title: lang.confirm,
                  type: ButtonType.error,
                  isShortText: true,
                  onTap: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                ),
                const SizedBox(height: AppSizes.spacingSmall),
                CustomButton(
                  title: lang.cancel,
                  type: ButtonType.neutral,
                  style: CustomStyle.outlined,
                  isShortText: true,
                  onTap: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

