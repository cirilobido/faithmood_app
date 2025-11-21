import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes/app_routes_names.dart';
import '../../../../widgets/widgets_exports.dart';
import '../_journal_state.dart';
import '../_journal_view_model.dart';
import '../widgets/_devotional_log_card.dart';
import '../widgets/_journal_date_filter_chip_modal.dart';
import '../widgets/_journal_filter_chip.dart';
import '../widgets/_journal_order_chip.dart';

class DevotionalsTab extends ConsumerStatefulWidget {
  const DevotionalsTab({super.key});

  @override
  ConsumerState<DevotionalsTab> createState() => _DevotionalsTabState();
}

class _DevotionalsTabState extends ConsumerState<DevotionalsTab> {
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
        !state.isLoadingMoreDevotionalLogs &&
        !state.isLoadingDevotionalLogs &&
        state.hasMoreDevotionalLogs) {
      vm.loadMoreDevotionalLogs();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    if (state.isLoadingDevotionalLogs && state.devotionalLogs.isEmpty) {
      return const Center(
        child: LoadingIndicator(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
      );
    }

    if (state.devotionalLogsError && state.devotionalLogs.isEmpty) {
      return ErrorState(
        message: lang.unableToLoadJournalEntries,
        imagePath: AppIcons.sadPetImage,
      );
    }

    if (state.devotionalLogs.isEmpty) {
      return Center(
        child: Text(
          lang.noJournalEntries,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
          ),
          sliver: SliverList.separated(
            itemCount: state.devotionalLogs.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.spacingMedium),
            itemBuilder: (context, index) {
              final log = state.devotionalLogs[index];
              return DevotionalLogCard(
                log: log,
                onTap: () {
                  if (log.id != null) {
                    context.push(
                      Routes.devotionalLogDetails,
                      extra: {
                        'id': log.id!,
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
        if (state.isLoadingMoreDevotionalLogs)
          const SliverToBoxAdapter(
            child: LoadingIndicator(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: AppSizes.spacingLarge)),
      ],
    );
  }
}

