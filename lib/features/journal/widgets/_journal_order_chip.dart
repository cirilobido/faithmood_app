import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../_journal_view_model.dart';

class JournalOrderChip extends ConsumerWidget {
  const JournalOrderChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final state = ref.watch(journalViewModelProvider);
    final vm = ref.read(journalViewModelProvider.notifier);
    final isAscending = state.order == 'asc';

    return GestureDetector(
      onTap: () {
        final newOrder = isAscending ? 'desc' : 'asc';
        vm.sortMoodSessions(state.sortBy, newOrder);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingXSmall,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: theme.colorScheme.primary,
            width: AppSizes.borderWithSmall,
          ),
        ),
        child: Text(
          '${lang.order}: ${isAscending ? "▲" : "▼"}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
