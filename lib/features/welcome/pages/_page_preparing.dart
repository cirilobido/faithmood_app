import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_welcome_view_model.dart';
import '../widgets/_section_container.dart';

class PagePreparing extends ConsumerWidget {
  const PagePreparing({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final vm = ref.read(welcomeViewModelProvider.notifier);

    return SectionContainer(
      title: lang.preparingPageTitle,
      subtitle: lang.preparingPageSubtitle,
      centerTitle: true,
      centerSubtitle: true,
      spacingAfterSubtitle: AppSizes.spacingXLarge,
      content: TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 4),
        tween: Tween<double>(begin: 0.0, end: 1),
        onEnd: vm.nextPage,
        builder: (context, value, child) {
          final percent = (value * 100).round();
          String dynamicText;
          if (percent < 33) {
            dynamicText = lang.preparingPageT1;
          } else if (percent < 66) {
            dynamicText = lang.preparingPageT2;
          } else {
            dynamicText = lang.preparingPageT3;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppSizes.spacingLarge),
              Text(
                '$percent%',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge,
              ),
              SizedBox(height: AppSizes.spacingLarge),
              GradientProgressBar(value: value),
              SizedBox(height: AppSizes.spacingLarge),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeInOut,
                child: Text(
                  dynamicText,
                  key: ValueKey(dynamicText),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

