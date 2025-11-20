import 'package:flutter/material.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';

class JournalTabSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const JournalTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingXSmall),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              context: context,
              theme: theme,
              label: lang.emotions,
              isSelected: selectedIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),
          const SizedBox(width: AppSizes.spacingXSmall),
          Expanded(
            child: _buildTab(
              context: context,
              theme: theme,
              label: lang.devotionals,
              isSelected: selectedIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required ThemeData theme,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingSmall,
          horizontal: AppSizes.paddingMedium,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
