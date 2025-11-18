import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_welcome_view_model.dart';
import '../widgets/_section_container.dart';

class PageProfile extends ConsumerWidget {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(welcomeViewModelProvider.notifier);
    final lang = S.of(context);

    return SectionContainer(
      title: lang.profilePageTitle,
      subtitle: lang.profilePageSubtitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            label: lang.firstName,
            hintText: 'Laura',
            required: true,
            controller: vm.nameController,
            focusNode: vm.nameFocus,
            textInputAction: TextInputAction.next,
            validations: [FieldTypeValidation.name],
          ),

          SizedBox(height: AppSizes.spacingLarge),

          InputField(
            label: lang.age,
            hintText: '25',
            required: true,
            controller: vm.ageController,
            focusNode: vm.ageFocus,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),

          SizedBox(height: AppSizes.spacingLarge),

          InputField(
            readOnly: true,
            label: lang.language,
            controller: vm.langController,
            onTap: () async {
              await LanguageBottomSheet.show(
                context: context,
                selectedLang: vm.selectedLang,
                onChanged: (value) {
                  vm.selectedLang = value ?? Lang.en;
                  vm.langController.text = Lang.toTitle(value: value) ?? '';
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
