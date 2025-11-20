import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/widgets_exports.dart';
import '../_journal_view_model.dart';

class JournalMoodFilterChipModal extends ConsumerStatefulWidget {
  const JournalMoodFilterChipModal({super.key});

  @override
  ConsumerState<JournalMoodFilterChipModal> createState() => _JournalMoodFilterChipModalState();
}

class _JournalMoodFilterChipModalState extends ConsumerState<JournalMoodFilterChipModal> {
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
    final emotionalMoods = journalVm.emotionalMoods;
    final spiritualMoods = journalVm.spiritualMoods;

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
            lang.moreFilters,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.emotionalMood,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSizes.spacingSmall),
                  if (emotionalMoods.isEmpty)
                    Text(
                      lang.noEmotionalMoodsAvailable,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color,
                      ),
                    )
                  else
                    SizedBox(
                      height: AppSizes.filterTagChipHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: emotionalMoods.length,
                        itemBuilder: (context, index) {
                          final mood = emotionalMoods[index];
                          final isSelected = _selectedEmotionalMoodId == mood.id;
                          return Container(
                            margin: const EdgeInsets.only(right: AppSizes.spacingSmall),
                            child: _buildMoodChip(
                              context: context,
                              theme: theme,
                              label: mood.name ?? '',
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedEmotionalMoodId = isSelected ? null : mood.id;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: AppSizes.spacingMedium),
                  Text(
                    lang.spiritualMood,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSizes.spacingSmall),
                  if (spiritualMoods.isEmpty)
                    Text(
                      lang.noSpiritualMoodsAvailable,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color,
                      ),
                    )
                  else
                    SizedBox(
                      height: AppSizes.filterTagChipHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: spiritualMoods.length,
                        itemBuilder: (context, index) {
                          final mood = spiritualMoods[index];
                          final isSelected = _selectedSpiritualMoodId == mood.id;
                          return Container(
                            margin: const EdgeInsets.only(right: AppSizes.spacingSmall),
                            child: _buildMoodChip(
                              context: context,
                              theme: theme,
                              label: mood.name ?? '',
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedSpiritualMoodId = isSelected ? null : mood.id;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
            const SizedBox(height: AppSizes.spacingLarge),
            CustomButton(
              title: lang.applyFilters,
              type: ButtonType.neutral,
              isShortText: true,
              onTap: () {
                journalVm.filterByEmotionalMood(_selectedEmotionalMoodId);
                journalVm.filterBySpiritualMood(_selectedSpiritualMoodId);
                journalVm.filterByHasNote(_hasNote);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            CustomButton(
              title: lang.clearFilters,
              type: ButtonType.neutral,
              style: CustomStyle.outlined,
              isShortText: true,
              onTap: () {
                if(_selectedEmotionalMoodId != null) {
                  setState(() {
                    _selectedEmotionalMoodId = null;
                  });
                  journalVm.filterByEmotionalMood(_selectedEmotionalMoodId);
                }
                if(_selectedSpiritualMoodId != null) {
                setState(() {
                  _selectedSpiritualMoodId = null;
                });
                  journalVm.filterBySpiritualMood(_selectedSpiritualMoodId);
                }
                if(_hasNote != null) {
                  setState(() {
                    _hasNote = null;
                  });
                  journalVm.filterByHasNote(_hasNote);
                }
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      ),
    );
  }

  Widget _buildMoodChip({
    required BuildContext context,
    required ThemeData theme,
    required String label,
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

