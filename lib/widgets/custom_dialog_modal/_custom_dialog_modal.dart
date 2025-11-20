import 'package:flutter/material.dart';

import '../../../core/core_exports.dart';
import '../widgets_exports.dart';

class CustomDialogModal {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required String buttonTitle,
    required Future<void> Function() onPrimaryTap,
    ButtonType? buttonType,
    String? iconPath,
    bool dismissible = true,
  }) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text(title, style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          content: Text(content, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
          icon: (iconPath != null)
              ? Image.asset(iconPath, height: AppSizes.dialogIconSize)
              : null,
          actions: <Widget>[
            CustomButton(
              title: buttonTitle,
              type: buttonType ?? ButtonType.primary,
              onTap: () async {
                await onPrimaryTap();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
