import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../../widgets/widgets_exports.dart';
import '_home_view_model.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(homeViewModelProvider.notifier);
    final state = ref.watch(homeViewModelProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userName = vm.getUserName() ?? '';
    final greeting = vm.getGreeting();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(context, theme, greeting, userName),
              const SizedBox(height: AppSizes.spacingLarge),

              // Banner Carousel Section
              DevotionalBanner(
                isLoading: state.isLoadingDevotional,
                hasError: state.errorDevotional,
                coverImage: vm.getDevotionalCoverImage(),
                title: vm.getDevotionalTitle(),
                content: vm.getDevotionalContent(),
                categoryTitle: vm.getDevotionalCategoryTitle(),
                isPremium: vm.isDevotionalPremium(),
              ),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Week in Emotions Section
              _buildWeekEmotionsSection(context, theme),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Verse of the Day Section
              VerseOfDayCard(
                isLoading: state.isLoading,
                verse: state.dailyVerse,
              ),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Choose Your Next Step Section
              _buildNextStepSection(context, theme, isDark),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Premium Promotion Section
              PremiumPromotionCard(
                title: '✨ Your journey is begins today',
                description: 'Unlock more category_devotionals, guided plans, moods, and an ad-free experience.',
                buttonTitle: 'Discover Premium',
                imagePath: AppIcons.happyPetImage,
              ),
              const SizedBox(height: AppSizes.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    String greeting,
    String userName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: theme.textTheme.headlineMedium,
            children: [
              TextSpan(text: '$greeting, '),
              TextSpan(
                text: userName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildWeekEmotionsSection(BuildContext context, ThemeData theme) {
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('💫', style: theme.textTheme.titleMedium),
                const SizedBox(width: AppSizes.spacingSmall),
                Text(
                  lang.yourWeekInEmotions,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.textTheme.labelSmall?.color!,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        SizedBox(
          height: AppSizes.homeWeekItemsContainerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              final dates = ['04', '05', '06', '07', '08', '09', '10'];
              final isToday = index == 3;
              final hasEmotion = index < 4;

              return Container(
                width: AppSizes.homeWeekItemsWidth,
                margin: const EdgeInsets.only(right: AppSizes.spacingSmall),
                decoration: BoxDecoration(
                  color: isToday
                      ? theme.colorScheme.secondary.withValues(alpha: 0.60)
                      : hasEmotion
                      ? theme.colorScheme.primary.withValues(alpha: 0.20)
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.paddingSmall,
                  horizontal: AppSizes.paddingXSmall,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          days[index],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.labelSmall?.color!,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(dates[index], style: theme.textTheme.titleSmall),
                      ],
                    ),
                    if (hasEmotion)
                      Text('😁', style: theme.textTheme.titleLarge)
                    else
                      SvgPicture.asset(
                        AppIcons.dottedCircleIcon,
                        width: AppSizes.iconSizeRegular,
                        height: AppSizes.iconSizeRegular,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildNextStepSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: lang.chooseYourNextStep,
          titleStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        ActionCard(
          title: lang.growWithGuidance,
          description: lang.ffollowGuidedDailyDevotionals,
          color: theme.colorScheme.tertiary,
          icon: AppIcons.openBookIcon,
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        ActionCard(
          title: lang.yourJournal,
          description: lang.captureYourThoughtsEachDay,
          color: theme.colorScheme.primary,
          icon: AppIcons.journalIcon,
        ),
      ],
    );
  }

}
