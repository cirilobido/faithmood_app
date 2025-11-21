import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../widgets_exports.dart';

class NoteDisplay extends StatelessWidget {
  final String? note;
  final bool isEditing;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final bool isSaving;

  const NoteDisplay({
    super.key,
    this.note,
    this.isEditing = false,
    this.controller,
    this.onChanged,
    this.onSave,
    this.onCancel,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    if (isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.myThoughts, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSizes.spacingSmall),
          InputField(
            controller: controller,
            isMultiline: true,
            hintText: lang.myThoughts,
            onChanged: onChanged,
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          Column(
            children: [
              CustomButton(
                title: lang.save,
                type: ButtonType.primary,
                isLoading: isSaving,
                isShortText: true,
                onTap: onSave ?? () {},
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              CustomButton(
                title: lang.cancel,
                type: ButtonType.neutral,
                style: CustomStyle.outlined,
                isShortText: true,
                onTap: onCancel ?? () {},
              ),
            ],
          ),
        ],
      );
    }

    if (note == null || note!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.myThoughts, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSizes.spacingSmall),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(note!, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }
}

