import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../../widgets/widgets_exports.dart';
import '_home_view_model.dart';
import '_home_state.dart';

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
              _buildBannerSection(context, ref, theme, isDark, state),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Week in Emotions Section
              _buildWeekEmotionsSection(context, theme),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Verse of the Day Section
              _buildVerseOfDaySection(context, ref, theme, isDark, state),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Choose Your Next Step Section
              _buildNextStepSection(context, theme, isDark),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Premium Promotion Section
              _buildPremiumSection(context, theme, isDark),
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

  Widget _buildBannerSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    bool isDark,
    HomeState state,
  ) {
    final vm = ref.read(homeViewModelProvider.notifier);
    final coverImage = vm.getDevotionalCoverImage();
    final title = vm.getDevotionalTitle();
    final content = vm.getDevotionalContent();
    final categoryTitle = vm.getDevotionalCategoryTitle();
    final isPremium = vm.isDevotionalPremium();

    return SizedBox(
      height: 148,
      child: state.isLoadingDevotional
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
                gradient: LinearGradient(
                  colors: [
                    AppColors.tertiary.withOpacity(0.3),
                    AppColors.secondary.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  child: SizedBox(
                    width: AppSizes.iconSizeMedium,
                    height: AppSizes.iconSizeMedium,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
              ),
            )
          : state.errorDevotional
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
                gradient: LinearGradient(
                  colors: [
                    AppColors.tertiary.withOpacity(0.3),
                    AppColors.secondary.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.primary),
                    const SizedBox(height: AppSizes.spacingXSmall),
                    Text(
                      'Unable to load devotional',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                // Navigation can be added later
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
                  gradient: coverImage != null
                      ? null
                      : LinearGradient(
                          colors: [
                            AppColors.tertiary.withOpacity(0.3),
                            AppColors.secondary.withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                ),
                child: Stack(
                  children: [
                    if (coverImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusNormal,
                        ),
                        child: Image.network(
                          coverImage,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.tertiary.withOpacity(0.3),
                                    AppColors.secondary.withOpacity(0.3),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    // Gradient overlay for better text readability
                    if (coverImage != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusNormal,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (categoryTitle != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.paddingSmall,
                                    vertical: AppSizes.paddingXXSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusSmall,
                                    ),
                                  ),
                                  child: Text(
                                    categoryTitle,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (isPremium)
                                Container(
                                  padding: const EdgeInsets.all(
                                    AppSizes.paddingXXSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.star,
                                    size: 16,
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title.isNotEmpty)
                                Text(
                                  title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: coverImage != null
                                        ? Colors.white
                                        : theme.textTheme.titleMedium?.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (content.isNotEmpty) ...[
                                const SizedBox(height: AppSizes.spacingXSmall),
                                Text(
                                  content,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: coverImage != null
                                        ? Colors.white.withOpacity(0.9)
                                        : theme.textTheme.bodySmall?.color,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _buildVerseOfDaySection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    bool isDark,
    HomeState state,
  ) {
    final lang = S.of(context);
    final vm = ref.read(homeViewModelProvider.notifier);
    final verseText = vm.getVerseText();
    final verseRef = vm.getVerseRef();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
          ),
          child: state.isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.paddingLarge),
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.paddingMedium),
                      child: SizedBox(
                        width: AppSizes.iconSizeMedium,
                        height: AppSizes.iconSizeMedium,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                  ),
                )
              : verseText.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.verseOfTheDay,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color!,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    Text(
                      '"$verseText"',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (verseRef.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.spacingSmall),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          verseRef,
                          textAlign: TextAlign.end,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.labelSmall?.color!,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.verseOfTheDay,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color!,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    Text(
                      lang.unableToLoadVersePleaseTryAgainLater,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color!,
                      ),
                    ),
                  ],
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
        Text(
          lang.chooseYourNextStep,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.labelSmall?.color!,
          ),
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        _buildActionCard(
          context,
          theme,
          lang.growWithGuidance,
          lang.ffollowGuidedDailyDevotionals,
          theme.colorScheme.tertiary,
          AppIcons.openBookIcon,
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        _buildActionCard(
          context,
          theme,
          lang.yourJournal,
          lang.captureYourThoughtsEachDay,
          theme.colorScheme.primary,
          AppIcons.journalIcon,
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    ThemeData theme,
    String title,
    String description,
    Color color,
    String icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        border: Border.all(
          color: color.withValues(alpha: 0.6),
          width: AppSizes.borderWithSmall,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleIconCard(
            iconPath: icon,
            iconColor: color,
            backgroundColor: color.withValues(alpha: 0.15),
            borderColor: color.withValues(alpha: 0.15),
            borderWidth: 0,
          ),
          const SizedBox(width: AppSizes.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.labelSmall?.color!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  width: AppSizes.welcomeBellIconSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✨ Your journey is begins today',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingSmall),
                      Text(
                        'Unlock more category_devotionals, guided plans, moods, and an ad-free experience.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: -30,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      AppIcons.happyPetImage,
                      width: AppSizes.dialogIconSize,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          CustomButton(
            title: 'Discover Premium',
            type: ButtonType.neutral,
            isShortText: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
