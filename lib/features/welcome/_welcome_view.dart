import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../widgets/widgets_exports.dart';
import '_welcome_view_model.dart';
import 'widgets/_welcome_background.dart';
import 'widgets/_welcome_bottom_buttons.dart';
import 'widgets/_welcome_page_switcher.dart';
import 'widgets/_welcome_top_bar.dart';

class WelcomeView extends ConsumerWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(welcomeViewModelProvider.notifier);
    final state = ref.watch(welcomeViewModelProvider);

    final pageIndex = vm.getCurrentBackendIndex();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          WelcomeBackground(index: pageIndex, isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSizes.spacingLarge),
                WelcomeTopBar(
                  index: pageIndex,
                  progress: state.progress,
                  onBack: vm.previousPage,
                ),
                const SizedBox(height: AppSizes.spacingSmall),
                Expanded(child: WelcomePageSwitcher(index: pageIndex)),
                const SizedBox(height: AppSizes.spacingMedium),
                WelcomeBottomButtons(
                  index: pageIndex,
                  isLoading: state.isLoading,
                  onNext: () {
                    final error = vm.validatePage(pageIndex, context);
                    if (error != null) {
                      CustomSnackBar.show(
                        context,
                        backgroundColor: AppColors.error,
                        message: error,
                      );
                      return;
                    }
                    vm.goToNextOrFinish(context);
                  },
                  onPrimaryTapOverride: pageIndex == 7
                      ? () {
                          vm.requestNotificationPermission().whenComplete(() {
                            vm.goToNextOrFinish(context);
                          });
                        }
                      : pageIndex == 11
                          ? () {
                              vm.rateApp(context);
                            }
                          : null,
                  onSecondaryTap: (pageIndex == 7 || pageIndex == 11)
                      ? () {
                          vm.goToNextOrFinish(context);
                        }
                      : null,
                ),
                const SizedBox(height: AppSizes.spacingLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
