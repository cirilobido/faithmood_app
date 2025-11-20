import 'package:flutter/material.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/widgets_exports.dart';

class PageAddNote extends StatelessWidget {
  final String note;
  final Function(String) onNoteChanged;

  const PageAddNote({
    super.key,
    required this.note,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            lang.howWouldYouDescribeYourDay,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Text(
            lang.writeWhatsOnYourHeart,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.labelSmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.outline.withValues(alpha: 0.7),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: InputField(
              hintText: '${lang.optional} ${lang.imGratefulFor}',
              textInputAction: TextInputAction.newline,
              isMultiline: true,
              initialValue: note,
              onChanged: onNoteChanged,
            ),
          ),
          const SizedBox(height: AppSizes.spacingXXLarge),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.labelSmall?.color,
              ),
              children: [
                TextSpan(text: '💡'),
                TextSpan(text: '${lang.tip}: ${lang.youCanRevisitThisNote}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
