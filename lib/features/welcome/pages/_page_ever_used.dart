import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_welcome_view_model.dart';
import '../widgets/_section_container.dart';

class PageEverUsed extends ConsumerWidget {
  const PageEverUsed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = S.of(context);
    final vm = ref.read(welcomeViewModelProvider.notifier);

    final options = {
      'yes': lang.everUsedBeforeQ1,
      'no': lang.everUsedBeforeQ2,
      'similar': lang.everUsedBeforeQ3,
    };

    return SectionContainer(
      title: lang.everUsedBeforeTitle,
      subtitle: null,
      spacingAfterTitle: AppSizes.spacingXXLarge,
      content: RadioListSelector(
        options: options,
        initialSelectedKey: vm.selectedEverUsed,
        onChanged: (v) => vm.selectedEverUsed = v,
      ),
    );
  }
}
