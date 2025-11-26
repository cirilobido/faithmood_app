import 'package:flutter/material.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';

class JournalTabSelector extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const JournalTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<JournalTabSelector> createState() => _JournalTabSelectorState();
}

class _JournalTabSelectorState extends State<JournalTabSelector> {
  int _previousIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    // Determine slide direction
    final isMovingRight = widget.selectedIndex > _previousIndex;
    final slideOffset = isMovingRight ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);

    // Update previous index
    if (_previousIndex != widget.selectedIndex) {
      _previousIndex = widget.selectedIndex;
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingXSmall),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTab(
                  context: context,
                  theme: theme,
                  label: lang.emotions,
                  isSelected: widget.selectedIndex == 0,
                  onTap: () => widget.onTabSelected(0),
                ),
              ),
              const SizedBox(width: AppSizes.spacingXSmall),
              Expanded(
                child: _buildTab(
                  context: context,
                  theme: theme,
                  label: lang.devotionals,
                  isSelected: widget.selectedIndex == 1,
                  onTap: () => widget.onTabSelected(1),
                ),
              ),
            ],
          ),
          // Animated indicator with slide animation
          _buildAnimatedIndicator(context, theme, slideOffset),
        ],
      ),
    );
  }

  Widget _buildAnimatedIndicator(
    BuildContext context,
    ThemeData theme,
    Offset slideOffset,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final tabWidth = (containerWidth - AppSizes.paddingXSmall * 2 - AppSizes.spacingXSmall) / 2;
        final indicatorLeft = widget.selectedIndex == 0
            ? AppSizes.paddingXSmall
            : AppSizes.paddingXSmall + tabWidth + AppSizes.spacingXSmall;

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: indicatorLeft,
          top: AppSizes.paddingXSmall,
          bottom: AppSizes.paddingXSmall,
          child: TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tween: Tween<Offset>(
              begin: slideOffset,
              end: Offset.zero,
            ),
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(offset.dx * tabWidth, 0),
                child: Container(
                  width: tabWidth,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                ),
              );
            },
          ),
        );
      },
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
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onSecondary
                  : theme.textTheme.titleSmall?.color,
            ) ?? const TextStyle(),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
