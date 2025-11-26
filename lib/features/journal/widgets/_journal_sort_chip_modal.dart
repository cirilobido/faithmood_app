import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/widgets_exports.dart';
import '../_journal_view_model.dart';

class JournalSortChipModal extends ConsumerStatefulWidget {
  const JournalSortChipModal({super.key});

  @override
  ConsumerState<JournalSortChipModal> createState() => _JournalSortChipModalState();
}

class _JournalSortChipModalState extends ConsumerState<JournalSortChipModal> {
  String _sortBy = 'createdAt';
  String _order = 'desc';

  @override
  void initState() {
    super.initState();
    final journalState = ref.read(journalViewModelProvider);
    _sortBy = journalState.sortBy;
    _order = journalState.order;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final journalVm = ref.read(journalViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusNormal),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.sortBy,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Text(
            lang.sortBy,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Wrap(
            spacing: AppSizes.spacingSmall,
            runSpacing: AppSizes.spacingSmall,
            children: [
              _buildChip(
                context: context,
                theme: theme,
                label: lang.date,
                value: 'createdAt',
                isSelected: _sortBy == 'createdAt',
                onTap: () => setState(() => _sortBy = 'createdAt'),
              ),
              _buildChip(
                context: context,
                theme: theme,
                label: lang.emotionalMood,
                value: 'emotionalMoodId',
                isSelected: _sortBy == 'emotionalMoodId',
                onTap: () => setState(() => _sortBy = 'emotionalMoodId'),
              ),
              _buildChip(
                context: context,
                theme: theme,
                label: lang.spiritualMood,
                value: 'spiritualMoodId',
                isSelected: _sortBy == 'spiritualMoodId',
                onTap: () => setState(() => _sortBy = 'spiritualMoodId'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          Text(
            lang.order,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Wrap(
            spacing: AppSizes.spacingSmall,
            runSpacing: AppSizes.spacingSmall,
            children: [
              _buildChip(
                context: context,
                theme: theme,
                label: lang.ascending,
                value: 'asc',
                isSelected: _order == 'asc',
                onTap: () => setState(() => _order = 'asc'),
              ),
              _buildChip(
                context: context,
                theme: theme,
                label: lang.descending,
                value: 'desc',
                isSelected: _order == 'desc',
                onTap: () => setState(() => _order = 'desc'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: lang.clearFilters,
                  type: ButtonType.secondary,
                  onTap: () {
                    journalVm.sortMoodSessions('updatedAt', 'desc');
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: AppSizes.spacingMedium),
              Expanded(
                child: CustomButton(
                  title: lang.applyFilters,
                  type: ButtonType.primary,
                  onTap: () {
                    journalVm.sortMoodSessions(_sortBy, _order);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required ThemeData theme,
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: AppSizes.borderWithSmall,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

