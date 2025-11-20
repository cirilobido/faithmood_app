import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '_journal_view_model.dart';
import 'pages/_moods_tab.dart';
import 'pages/_devotionals_tab.dart';
import 'widgets/_journal_tab_selector.dart';

class JournalView extends ConsumerWidget {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journalViewModelProvider);
    final vm = ref.read(journalViewModelProvider.notifier);
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
                vertical: AppSizes.paddingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.myJournal,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.spacingMedium),
                  JournalTabSelector(
                    selectedIndex: state.selectedTab,
                    onTabSelected: (index) {
                      vm.switchTab(index);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.selectedTab == 0
                  ? const MoodsTab()
                  : const DevotionalsTab(),
            ),
          ],
        ),
      ),
    );
  }
}

