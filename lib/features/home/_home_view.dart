import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../../routes/app_routes_names.dart';
import '../../widgets/widgets_exports.dart';
import '_home_view_model.dart';
import 'widgets/_home_mood_selector.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowReviewModal();
    });
  }

  Future<void> _checkAndShowReviewModal() async {
    if (!mounted) return;
    final vm = ref.read(homeViewModelProvider.notifier);
    final shouldShow = await vm.shouldShowReviewModal();
    if (shouldShow && mounted) {
      ReviewRequestModal.show(
        context: context,
        onReview: () => vm.onReviewTapped(),
        onNeverAsk: () => vm.onNeverAskTapped(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(homeViewModelProvider.notifier);
    final state = ref.watch(homeViewModelProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = S.of(context);
    final userName = vm.getUserName() ?? '';
    final greeting = vm.getGreeting(lang);
    final greetingSubtitle = vm.getGreetingSubtitle(lang);

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
              _buildHeader(context, theme, greeting, greetingSubtitle, userName),
              const SizedBox(height: AppSizes.spacingLarge),

              // Verse of the Day Section
              VerseOfDayCard(
                isLoading: state.isLoading,
                verse: state.dailyVerse,
              ),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Account Setup Alert
              if (_shouldShowAccountSetupAlert(ref))
                ...[
                  const AccountSetupAlert(),
                  const SizedBox(height: AppSizes.spacingLarge),
                ],

              // Banner Carousel Section
              // DevotionalBanner(
              //   isLoading: state.isLoadingDevotional,
              //   hasError: state.errorDevotional,
              //   coverImage: vm.getDevotionalCoverImage(),
              //   title: vm.getDevotionalTitle(),
              //   content: vm.getDevotionalContent(),
              //   categoryTitle: vm.getDevotionalCategoryTitle(),
              //   isPremium: vm.isDevotionalPremium(),
              // ),
              // const SizedBox(height: AppSizes.spacingXLarge),

              // Mood Selection Section
              const HomeMoodSelector(),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Week in Emotions Section
              _buildWeekEmotionsSection(context, theme, ref),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Choose Your Next Step Section
              _buildNextStepSection(context, theme, isDark),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Premium Promotion Section
              PremiumPromotionCard(
                title: lang.yourJourneyBeginsToday,
                description: lang.unlockMoreDevotionalsAdvanceStats,
                buttonTitle: lang.discoverPremium,
                imagePath: AppIcons.happyPetImage,
                onButtonTap: () {
                  context.push(Routes.subscription);
                },
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
    String greetingSubtitle,
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
        Text(greetingSubtitle, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildWeekEmotionsSection(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    final lang = S.of(context);
    final state = ref.watch(homeViewModelProvider);
    final vm = ref.read(homeViewModelProvider.notifier);

    final weekDates = vm.getCurrentWeekDates();
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final userLang = ref.read(authProvider).user?.lang;

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
        if (state.isLoadingWeekMoods)
          SizedBox(
            height: AppSizes.homeWeekItemsContainerHeight,
            child: const Center(child: LoadingIndicator()),
          )
        else
          SizedBox(
            height: AppSizes.homeWeekItemsContainerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDates.asMap().entries.map((entry) {
                final index = entry.key;
                final date = entry.value;
                final dateOnly = DateTime(date.year, date.month, date.day);
                final isToday = dateOnly.isAtSameMomentAs(todayOnly);
                final isFuture = dateOnly.isAfter(todayOnly);
                final daySessions = state.weekMoodSessions[dateOnly] ?? [];
                final hasData = daySessions.isNotEmpty;

                Color backgroundColor;
                if (isToday) {
                  backgroundColor = theme.colorScheme.secondary.withValues(
                    alpha: 0.6,
                  );
                } else if (isFuture) {
                  backgroundColor = theme.colorScheme.onSurface;
                } else{
                  backgroundColor = theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  );
                }

                String? moodEmoji;
                if (hasData && daySessions.isNotEmpty) {
                  final firstSession = daySessions.first;
                  moodEmoji = firstSession.emotional?.mood?.icon;
                }

                return Container(
                  width: AppSizes.homeWeekItemsWidth,
                  margin: EdgeInsets.only(
                    right: index < weekDates.length - 1
                        ? AppSizes.spacingSmall
                        : 0,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
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
                            vm.getDayName(date, userLang),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.textTheme.labelSmall?.color!,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            vm.getDayNumber(date),
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      if (hasData && moodEmoji != null && moodEmoji.isNotEmpty)
                        Text(moodEmoji, style: theme.textTheme.titleLarge)
                      else
                        SvgPicture.asset(
                          AppIcons.dottedCircleIcon,
                          width: AppSizes.iconSizeRegular,
                          height: AppSizes.iconSizeRegular,
                          colorFilter: ColorFilter.mode(
                            theme.iconTheme.color!,
                            BlendMode.srcIn,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  bool _shouldShowAccountSetupAlert(WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final email = user?.email;
    return email == null || email.isEmpty;
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
          description: lang.followGuidedDailyDevotionals,
          color: theme.colorScheme.tertiary,
          icon: AppIcons.openBookIcon,
          onTap: () {
            context.go(Routes.devotional);
          },
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        ActionCard(
          title: lang.yourJournal,
          description: lang.captureYourThoughtsEachDay,
          color: theme.colorScheme.primary,
          icon: AppIcons.journalIcon,
          onTap: () {
            context.go(Routes.journal);
          },
        ),
      ],
    );
  }
}
