import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../_add_mood_state.dart';

class PageSpiritualMoods extends StatelessWidget {
  final AddMoodState state;
  final Function(Mood) onMoodSelected;

  const PageSpiritualMoods({
    super.key,
    required this.state,
    required this.onMoodSelected,
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
            lang.whereIsYourHeartToday,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Text(
            lang.selectStateThatResonates,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.labelSmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Expanded(
            child: ListView.separated(
              itemCount: state.spiritualMoods.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.spacingSmall),
              itemBuilder: (context, index) {
                final mood = state.spiritualMoods[index];
                final isSelected = state.selectedSpiritualMood?.id == mood.id;
                final moodId = mood.id?.toString() ?? '';

                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingXSmall,
                    horizontal: AppSizes.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.onSurface,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.3)
                          : theme.colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: ListTileTheme(
                    horizontalTitleGap: 4,
                    child: RadioListTile<String>(
                      key: ValueKey(moodId),
                      value: moodId,
                      groupValue: isSelected ? moodId : null,
                      onChanged: (_) {
                        triggerHapticFeedback(HapticsType.selection, context: context);
                        onMoodSelected(mood);
                      },
                      title: Row(
                        children: [
                          if (mood.icon != null && mood.icon!.isNotEmpty) ...[
                            Text(
                              mood.icon!,
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(width: AppSizes.spacingSmall),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mood.name ?? '',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                                ),
                                if (mood.description != null &&
                                    mood.description!.isNotEmpty) ...[
                                  const SizedBox(height: AppSizes.spacingXSmall),
                                  Text(
                                    mood.description!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.labelSmall?.color,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return theme.colorScheme.onSurface;
                        }
                        return theme.colorScheme.outline;
                      }),
                      activeColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

