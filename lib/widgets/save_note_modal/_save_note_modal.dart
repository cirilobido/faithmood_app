import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../widgets_exports.dart';

class SaveNoteModal {
  static Future<String?> show({
    required BuildContext context,
    String? initialNote,
  }) async {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(context);
        final lang = S.of(context);
        final TextEditingController noteController = TextEditingController(text: initialNote ?? '');

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              alignment: Alignment.center,
              title: Text(lang.unsavedNoteTitle, textAlign: TextAlign.center, style: theme.textTheme.titleSmall),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.unsavedNoteMessage,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    InputField(
                      hintText: lang.whatsOnYourHeartToday,
                      textInputAction: TextInputAction.newline,
                      isMultiline: true,
                      controller: noteController,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                CustomButton(
                  title: lang.saveNotes,
                  type: ButtonType.primary,
                  isShortText: true,
                  onTap: () {
                    final savedNote = noteController.text.trim();
                    noteController.dispose();
                    Navigator.of(dialogContext).pop(savedNote);
                  },
                ),
                const SizedBox(width: AppSizes.spacingSmall),
                CustomButton(
                  title: lang.continueWithoutNote,
                  type: ButtonType.neutral,
                  style: CustomStyle.outlined,
                  isShortText: true,
                  onTap: () {
                    noteController.dispose();
                    Navigator.of(dialogContext).pop(null);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

