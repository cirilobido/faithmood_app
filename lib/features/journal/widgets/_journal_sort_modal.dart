import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/widgets_exports.dart';
import '../_journal_view_model.dart';

class JournalSortModal extends ConsumerStatefulWidget {
  const JournalSortModal({super.key});

  @override
  ConsumerState<JournalSortModal> createState() => _JournalSortModalState();
}

class _JournalSortModalState extends ConsumerState<JournalSortModal> {
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
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
            RadioListTile<String>(
              value: 'updatedAt',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
              title: Text(lang.date),
            ),
            RadioListTile<String>(
              value: 'emotionalMoodId',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
              title: Text(lang.emotionalMood),
            ),
            RadioListTile<String>(
              value: 'spiritualMoodId',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
              title: Text(lang.spiritualMood),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Text(
              lang.order,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            RadioListTile<String>(
              value: 'asc',
              groupValue: _order,
              onChanged: (value) {
                setState(() {
                  _order = value!;
                });
              },
              title: Text(lang.ascending),
            ),
            RadioListTile<String>(
              value: 'desc',
              groupValue: _order,
              onChanged: (value) {
                setState(() {
                  _order = value!;
                });
              },
              title: Text(lang.descending),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            CustomButton(
              title: lang.applyFilters,
              type: ButtonType.primary,
              onTap: () {
                journalVm.sortMoodSessions(_sortBy, _order);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

