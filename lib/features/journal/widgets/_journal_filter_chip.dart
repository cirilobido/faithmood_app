import 'package:flutter/material.dart';

import '../../../../core/core_exports.dart';

class JournalFilterChip extends StatelessWidget {
  final String label;
  final String? value;
  final bool isSelected;
  final bool isClearFilter;
  final VoidCallback onTap;

  const JournalFilterChip({
    super.key,
    required this.label,
    this.value,
    this.isSelected = false,
    this.isClearFilter = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = value ?? label;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingXSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : isClearFilter
              ? theme.colorScheme.error.withValues(alpha: 0.1)
              : theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : isClearFilter
                ? theme.colorScheme.error
                : theme.colorScheme.outline,
            width: AppSizes.borderWithSmall,
          ),
        ),
        child: Text(
          displayText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : isClearFilter
                ? theme.colorScheme.error
                : theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected || isClearFilter
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
