import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../_add_mood_state.dart';

class PageEmotionalMoods extends ConsumerWidget {
  final AddMoodState state;
  final Function(Mood) onMoodSelected;

  const PageEmotionalMoods({
    super.key,
    required this.state,
    required this.onMoodSelected,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final userName = ref.read(authProvider).user?.name ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            lang.heyHowAreYouFeelingToday.replaceAll('###', userName),
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Text(
            lang.chooseMoodThatBestReflects,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.labelSmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSizes.spacingMedium,
                mainAxisSpacing: AppSizes.spacingMedium,
                childAspectRatio: 1.1,
              ),
              itemCount: state.emotionalMoods.length,
              itemBuilder: (context, index) {
                final mood = state.emotionalMoods[index];
                final isSelected = state.selectedEmotionalMood?.id == mood.id;

                return InkWell(
                  onTap: () => onMoodSelected(mood),
                  borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.secondary.withValues(alpha: 0.2)
                          : theme.colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (mood.icon != null && mood.icon!.isNotEmpty)
                          Text(
                            mood.icon!,
                            style: theme.textTheme.headlineMedium,
                          ),
                        const SizedBox(height: AppSizes.spacingXSmall),
                        Text(
                          mood.name ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

