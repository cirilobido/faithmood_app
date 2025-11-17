import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_welcome_view_model.dart';
import '../widgets/_section_container.dart';

class PageGuidedPlan extends ConsumerWidget {
  const PageGuidedPlan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = S.of(context);
    final vm = ref.read(welcomeViewModelProvider.notifier);

    final options = {
      'yes-several': lang.guidedPlanQ1,
      'once-or-twice': lang.guidedPlanQ2,
      'no-first': lang.guidedPlanQ3,
    };

    return SectionContainer(
      title: lang.guidedPlanTitle,
      subtitle: null,
      spacingAfterTitle: AppSizes.spacingXXLarge,
      content: RadioListSelector(
        options: options,
        initialSelectedKey: vm.selectedGuidedPlan,
        onChanged: (v) => vm.selectedGuidedPlan = v,
      ),
    );
  }
}
