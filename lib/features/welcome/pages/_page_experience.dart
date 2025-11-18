import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../core/core_exports.dart';
import '../../../widgets/widgets_exports.dart';
import '../_welcome_view_model.dart';
import '../widgets/_section_container.dart';

class PageExperience extends ConsumerWidget {
  const PageExperience({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = S.of(context);
    final vm = ref.read(welcomeViewModelProvider.notifier);

    final options = {
      'find-peace': lang.experienceQ1,
      'manage-emotions': lang.experienceQ2,
      'strengthen-faith': lang.experienceQ3,
      'god-moment': lang.experienceQ4,
    };

    return SectionContainer(
      title: lang.experiencePageTitle,
      subtitle: null,
      spacingAfterTitle: AppSizes.spacingXXLarge,
      content: CheckBoxListSelector(
        options: options,
        initialSelectedKeys: vm.selectedExperience,
        onChanged: (list) {
          vm.selectedExperience
            ..clear()
            ..addAll(list);
        },
      ),
    );
  }
}
