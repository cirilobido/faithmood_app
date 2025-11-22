import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes/app_routes_names.dart';
import '../../../../widgets/widgets_exports.dart';
import '../_journal_state.dart';
import '../_journal_view_model.dart';
import 'package:intl/intl.dart';

import '../widgets/_journal_date_filter_chip_modal.dart';
import '../widgets/_journal_filter_chip.dart';
import '../widgets/_journal_mood_filter_chip_modal.dart';
import '../widgets/_journal_order_chip.dart';
import '../widgets/_mood_entry_card.dart';

class MoodsTab extends ConsumerStatefulWidget {
  const MoodsTab({super.key});

  @override
  ConsumerState<MoodsTab> createState() => _MoodsTabState();
}

class _MoodsTabState extends ConsumerState<MoodsTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final vm = ref.read(journalViewModelProvider.notifier);
    final state = ref.read(journalViewModelProvider);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoadingMore &&
        !state.isLoading &&
        state.hasMore) {
      vm.loadMoreMoodSessions();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _hasMoreFilters(JournalState state) {
    return state.selectedEmotionalMoodId != null ||
        state.selectedSpiritualMoodId != null;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy', 'en').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalViewModelProvider);
    final theme = Theme.of(context);
    final lang = S.of(context);

    final hasMoreFilters = _hasMoreFilters(state);
    final startDateValue = state.startDate != null ? _formatDate(state.startDate) : null;
    final endDateValue = state.endDate != null ? _formatDate(state.endDate) : null;
    final hasDateFilter = startDateValue != null || endDateValue != null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingSmall,
          ),
          child: SizedBox(
            height: AppSizes.filterTagChipHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const JournalOrderChip(),
                const SizedBox(width: AppSizes.spacingSmall),
                JournalFilterChip(
                  label: lang.date,
                  value: startDateValue != null && endDateValue != null
                      ? '$startDateValue - $endDateValue'
                      : startDateValue ?? endDateValue,
                  isSelected: hasDateFilter,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const JournalDateFilterChipModal(),
                    );
                  },
                ),
                const SizedBox(width: AppSizes.spacingSmall),
                JournalFilterChip(
                  label: lang.moreFilters,
                  value: null,
                  isSelected: hasMoreFilters,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const JournalMoodFilterChipModal(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        Expanded(
          child: _buildContent(context, theme, lang, state),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    S lang,
    JournalState state,
  ) {
    if (state.isLoading && state.moodSessions.isEmpty) {
      return const Center(
        child: LoadingIndicator(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
      );
    }

    if (state.error && state.moodSessions.isEmpty) {
      return ErrorState(
        message: lang.unableToLoadJournalEntries,
        imagePath: AppIcons.sadPetImage,
      );
    }

    final vm = ref.read(journalViewModelProvider.notifier);

    if (state.moodSessions.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => vm.loadMoodSessions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Text(
                lang.noJournalEntries,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => vm.loadMoodSessions(),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
            ),
            sliver: SliverList.separated(
              itemCount: state.moodSessions.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.spacingMedium),
              itemBuilder: (context, index) {
                final session = state.moodSessions[index];
                        return MoodEntryCard(
                          session: session,
                          onTap: () {
                            if (session.sessionId != null) {
                              context.push(
                                Routes.moodEntryDetails,
                                extra: {'sessionId': session.sessionId},
                              );
                            }
                          },
                        );
              },
            ),
          ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: LoadingIndicator(
                padding: EdgeInsets.all(AppSizes.paddingMedium),
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.spacingLarge)),
        ],
      ),
    );
  }
}

