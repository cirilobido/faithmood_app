import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '../../generated/l10n.dart';
import '../../routes/app_routes_names.dart';
import '../../widgets/widgets_exports.dart';
import '_profile_view_model.dart';
import 'widgets/_profile_header.dart';
import 'widgets/_stats_section.dart';
import 'widgets/_premium_upsell_card.dart';
import 'widgets/_analytics_section.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    devLogger('ProfileView.initState() called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      devLogger('ProfileView.addPostFrameCallback() executed');
      final viewModel = ref.read(profileViewModelProvider.notifier);
      devLogger(
        'ProfileView - viewModel.isDataLoaded: ${viewModel.isDataLoaded}',
      );

      if (!viewModel.isDataLoaded) {
        devLogger('ProfileView - calling loadData()');
        viewModel.loadData();
      } else {
        devLogger('ProfileView - data already loaded, skipping loadData()');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final state = ref.watch(profileViewModelProvider);

    final isPremium = state.isPremium ?? false;
    final analytics = viewModel.getCurrentStats(
      state.selectedPeriod ?? AnalyticsPeriod.thisWeek,
    );
    final streak = viewModel.getCurrentStreak(
      state.selectedPeriod ?? AnalyticsPeriod.thisWeek,
    );
    final totalLogs = analytics?.rangeStats?.totalLogs ?? 0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: AppSizes.paddingMedium,
          right: AppSizes.paddingMedium,
          left: AppSizes.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(user: state.user, isPremium: isPremium),
            const SizedBox(height: AppSizes.spacingSmall),
            const SizedBox(height: AppSizes.spacingMedium),
            Expanded(
              child: _ProfileContent(
                isPremium: isPremium,
                analytics: analytics,
                streak: streak,
                isLoading: state.isLoading,
                totalLogs: totalLogs,
                selectedPeriod: state.selectedPeriod,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final bool isPremium;
  final Analytics? analytics;
  final int? streak;
  final bool isLoading;
  final int totalLogs;
  final AnalyticsPeriod? selectedPeriod;

  const _ProfileContent({
    required this.isPremium,
    this.analytics,
    this.streak,
    required this.isLoading,
    required this.totalLogs,
    this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatsSection(
            isPremium: isPremium,
            analytics: analytics,
            streak: streak,
          ),
          if (isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                child: const CircularProgressIndicator(),
              ),
            ),
          if (!isPremium && totalLogs > 0) const PremiumUpsellCard(),
          if (totalLogs > 0 && !isLoading) ...[
            const SizedBox(height: AppSizes.spacingLarge),
            AnalyticsSection(
              isPremium: isPremium,
              analytics: analytics,
              isWeek:
                  selectedPeriod == AnalyticsPeriod.thisWeek ||
                  selectedPeriod == AnalyticsPeriod.lastWeek,
            ),
          ],
          if (totalLogs == 0 && !isLoading) ...[
            Center(
              child: Image.asset(
                AppIcons.greenChartImage,
                height: AppSizes.welcomeFigureIconSize,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Text(
              lang.startLoggingYourMoodsToSeeYourStats,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.textTheme.labelSmall?.color,
              ),
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            CustomButton(
              title: lang.addMoodEntry,
              type: ButtonType.secondary,
              onTap: () {
                context.push(Routes.addMood);
              },
            ),
          ],
          const SizedBox(height: AppSizes.spacingLarge),
        ],
      ),
    );
  }
}
