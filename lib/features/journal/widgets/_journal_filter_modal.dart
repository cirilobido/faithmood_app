import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/widgets_exports.dart';
import '../../mood/add_mood/_add_mood_view_model.dart';
import '../_journal_view_model.dart';

class JournalFilterModal extends ConsumerStatefulWidget {
  const JournalFilterModal({super.key});

  @override
  ConsumerState<JournalFilterModal> createState() => _JournalFilterModalState();
}

class _JournalFilterModalState extends ConsumerState<JournalFilterModal> {
  int? _selectedEmotionalMoodId;
  int? _selectedSpiritualMoodId;
  bool? _hasNote;

  @override
  void initState() {
    super.initState();
    final journalState = ref.read(journalViewModelProvider);
    _selectedEmotionalMoodId = journalState.selectedEmotionalMoodId;
    _selectedSpiritualMoodId = journalState.selectedSpiritualMoodId;
    _hasNote = journalState.hasNoteFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final journalVm = ref.read(journalViewModelProvider.notifier);
    final addMoodState = ref.watch(addMoodViewModelProvider);
    final emotionalMoods = addMoodState.emotionalMoods;
    final spiritualMoods = addMoodState.spiritualMoods;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.filterByMood,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emotional Mood',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    if (emotionalMoods.isEmpty)
                      Text(
                        'No moods available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.labelSmall?.color,
                        ),
                      )
                    else
                      ...emotionalMoods.map((mood) {
                        return RadioListTile<int>(
                          value: mood.id!,
                          groupValue: _selectedEmotionalMoodId,
                          onChanged: (value) {
                            setState(() {
                              _selectedEmotionalMoodId = value;
                            });
                          },
                          title: Text(mood.name ?? ''),
                        );
                      }),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Text(
                      'Spiritual Mood',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    if (spiritualMoods.isEmpty)
                      Text(
                        'No moods available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.labelSmall?.color,
                        ),
                      )
                    else
                      ...spiritualMoods.map((mood) {
                        return RadioListTile<int>(
                          value: mood.id!,
                          groupValue: _selectedSpiritualMoodId,
                          onChanged: (value) {
                            setState(() {
                              _selectedSpiritualMoodId = value;
                            });
                          },
                          title: Text(mood.name ?? ''),
                        );
                      }),
                    const SizedBox(height: AppSizes.spacingMedium),
                    Text(
                      'Has Note',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    RadioListTile<bool?>(
                      value: null,
                      groupValue: _hasNote,
                      onChanged: (value) {
                        setState(() {
                          _hasNote = value;
                        });
                      },
                      title: const Text('All'),
                    ),
                    RadioListTile<bool?>(
                      value: true,
                      groupValue: _hasNote,
                      onChanged: (value) {
                        setState(() {
                          _hasNote = value;
                        });
                      },
                      title: const Text('With Note'),
                    ),
                    RadioListTile<bool?>(
                      value: false,
                      groupValue: _hasNote,
                      onChanged: (value) {
                        setState(() {
                          _hasNote = value;
                        });
                      },
                      title: const Text('Without Note'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: lang.clearFilters,
                    type: ButtonType.secondary,
                    onTap: () {
                      setState(() {
                        _selectedEmotionalMoodId = null;
                        _selectedSpiritualMoodId = null;
                        _hasNote = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMedium),
                Expanded(
                  child: CustomButton(
                    title: lang.applyFilters,
                    type: ButtonType.primary,
                    onTap: () {
                      journalVm.filterByEmotionalMood(_selectedEmotionalMoodId);
                      journalVm.filterBySpiritualMood(_selectedSpiritualMoodId);
                      journalVm.filterByHasNote(_hasNote);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

