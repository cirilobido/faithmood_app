import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../routes/app_routes_names.dart';
import '../../../widgets/widgets_exports.dart';
import '../_home_view_model.dart';

class HomeMoodSelector extends ConsumerWidget {
  const HomeMoodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final vm = ref.read(homeViewModelProvider.notifier);
    final theme = Theme.of(context);
    final lang = S.of(context);

    if (state.isLoadingMoods) {
      return const SizedBox(
        height: 200,
        child: Center(child: LoadingIndicator()),
      );
    }

    if (state.moods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        border: Border.all(
          color: theme.colorScheme.secondary,
          width: AppSizes.borderWithSmall,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            lang.howAreYouFeeling,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: state.moods.asMap().entries.map((entry) {
              final index = entry.key;
              final mood = entry.value;
              final isSelected = state.selectedMood?.id == mood.id;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < state.moods.length - 1
                        ? AppSizes.spacingXSmall
                        : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      triggerHapticFeedback(
                        HapticsType.selection,
                        context: context,
                      );
                      if (isSelected) {
                        vm.selectMood(null);
                      } else {
                        vm.selectMood(mood);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: AppSizes.logoIconSize,
                          height: AppSizes.logoIconSize,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.secondary.withValues(
                                    alpha: 0.2,
                                  ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.outline,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: Center(
                            child: HomeMoodSelector._buildMoodIcon(mood, theme),
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXSmall),
                        Text(
                          mood.name ?? '',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.textTheme.labelSmall?.color,
                            fontWeight: theme.textTheme.titleSmall?.fontWeight,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          CustomButton(
            title: lang.logMood,
            type: ButtonType.secondary,
            isShortText: true,
            onTap: () {
              context.push(
                Routes.addMood,
                extra: {'preSelectedMood': state.selectedMood},
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildMoodIcon(Mood mood, ThemeData theme) {
    final animationPath = MoodAnimation.getAnimationPath(mood.key);

    if (animationPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        child: Image.asset(
          animationPath,
          width: AppSizes.iconSizeXLarge,
          height: AppSizes.iconSizeXLarge,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return HomeMoodSelector._buildEmojiFallback(mood, theme);
          },
        ),
      );
    }

    return HomeMoodSelector._buildEmojiFallback(mood, theme);
  }

  static Widget _buildEmojiFallback(Mood mood, ThemeData theme) {
    if (mood.icon != null && mood.icon!.isNotEmpty) {
      return Text(mood.icon!, style: theme.textTheme.headlineSmall);
    }
    return const SizedBox();
  }
}
