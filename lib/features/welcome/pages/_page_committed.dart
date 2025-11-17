import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_welcome_view_model.dart';
import '../widgets/_section_container.dart';

class PageCommitted extends ConsumerWidget {
  const PageCommitted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = S.of(context);
    final vm = ref.read(welcomeViewModelProvider.notifier);

    final options = {
      'extremely': lang.committedQ1,
      'very': lang.committedQ2,
      'somewhat': lang.committedQ3,
      'little': lang.committedQ4,
      'exploring': lang.committedQ5,
    };

    return SectionContainer(
      title: lang.committedPageTitle,
      subtitle: null,
      spacingAfterTitle: AppSizes.spacingXXLarge,
      content: RadioListSelector(
        options: options,
        initialSelectedKey: vm.selectedCommitted,
        onChanged: (v) => vm.selectedCommitted = v,
      ),
    );
  }
}
