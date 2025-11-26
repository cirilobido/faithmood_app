import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '_journal_view_model.dart';
import 'pages/_moods_tab.dart';
import 'pages/_devotionals_tab.dart';
import 'widgets/_journal_tab_selector.dart';

class JournalView extends ConsumerStatefulWidget {
  const JournalView({super.key});

  @override
  ConsumerState<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends ConsumerState<JournalView> {
  int _previousTab = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalViewModelProvider);
    final vm = ref.read(journalViewModelProvider.notifier);
    final theme = Theme.of(context);
    final lang = S.of(context);

    // Capture previous tab before updating
    final previousTab = _previousTab;
    final currentTab = state.selectedTab;
    
    // Determine slide direction based on tab change
    final isMovingRight = currentTab > previousTab;
    final slideOffset = isMovingRight ? const Offset(-0.1, 0.0) : const Offset(0.1, 0.0);

    // Update previous tab for next build
    if (_previousTab != currentTab) {
      _previousTab = currentTab;
    }

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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: slideOffset,
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: child,
                    ),
                  );
                },
                child: state.selectedTab == 0
                    ? const MoodsTab(key: ValueKey('moods'))
                    : const DevotionalsTab(key: ValueKey('devotionals')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

