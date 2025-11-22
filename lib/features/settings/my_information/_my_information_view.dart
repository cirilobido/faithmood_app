import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../routes/app_routes_names.dart';
import '../../../widgets/widgets_exports.dart';
import '_my_information_view_model.dart';

class MyInformationView extends ConsumerStatefulWidget {
  const MyInformationView({super.key});

  @override
  ConsumerState<MyInformationView> createState() => _MyInformationViewState();
}

class _MyInformationViewState extends ConsumerState<MyInformationView> {
  late bool isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  bool nameError = false;
  final TextEditingController _emailController = TextEditingController();
  bool emailError = false;
  final TextEditingController _ageController = TextEditingController();
  bool ageError = false;
  final TextEditingController _langController = TextEditingController();
  Lang? _selectedLang;

  void _initializeControllers(User? user) {
    if (user != null) {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _ageController.text = user.age?.toString() ?? '';
      _langController.text = Lang.toTitle(value: user.lang) ?? '';
      _selectedLang = user.lang;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myInformationViewModelProvider.notifier).loadData();
      final user = ref.read(authProvider).user;
      if (user != null) {
        _initializeControllers(user);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _langController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final state = ref.watch(myInformationViewModelProvider);

    ref.listen(myInformationViewModelProvider, (previous, next) {
      if (previous?.user != next.user && next.user != null && !isEditing) {
        _initializeControllers(next.user);
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      lang.personalInformation,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => setState(() => isEditing = !isEditing),
                    child: SvgPicture.asset(
                      !isEditing ? AppIcons.editIcon : AppIcons.closeIcon,
                      height: AppSizes.iconSizeRegular,
                      width: AppSizes.iconSizeRegular,
                      colorFilter: ColorFilter.mode(
                        theme.primaryIconTheme.color!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputField(
                          required: isEditing,
                          readOnly: !isEditing,
                          extraSpace: false,
                          label: lang.firstName,
                          hintText: lang.appName,
                          controller: _nameController,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validations: isEditing ? [FieldTypeValidation.name] : null,
                          onChanged: (value) {
                            setState(() {
                              nameError = InputValidations.validateName(
                                    context,
                                    value,
                                  ) !=
                                  null;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.spacingLarge),
                        InputField(
                          required: isEditing,
                          readOnly: !isEditing,
                          extraSpace: false,
                          label: lang.email,
                          hintText: lang.email,
                          controller: _emailController,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validations: isEditing ? [FieldTypeValidation.email] : null,
                          onChanged: (value) {
                            setState(() {
                              emailError = InputValidations.validateEmail(
                                    context,
                                    value,
                                  ) !=
                                  null;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.spacingLarge),
                        InputField(
                          required: isEditing,
                          readOnly: true,
                          extraSpace: false,
                          label: lang.language,
                          controller: _langController,
                          onTap: (!isEditing)
                              ? null
                              : () async {
                                  await LanguageBottomSheet.show(
                                    context: context,
                                    selectedLang: _selectedLang,
                                    onChanged: (value) {
                                      if (value != null) {
                                        _langController.text =
                                            Lang.toTitle(value: value) ?? '';
                                        _selectedLang = value;
                                        final langProvider = ref.watch(
                                          appLanguageProvider,
                                        );
                                        langProvider.changeLocale(
                                          Locale(value.name),
                                        );
                                      }
                                    },
                                  );
                                },
                        ),
                        const SizedBox(height: AppSizes.spacingSmall),
                        Text(
                          lang.thisUsedForAllYourMoodAnalysis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.textTheme.labelSmall?.color,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingLarge),
                        InputField(
                          required: isEditing,
                          readOnly: !isEditing,
                          extraSpace: false,
                          label: lang.age,
                          hintText: lang.age,
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                ageError = false;
                                return;
                              }
                              final age = int.tryParse(value);
                              ageError = age == null || age <= 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              CustomButton(
                isLoading: state.isLoading,
                title: isEditing ? lang.updateInformation : lang.deleteAccount,
                type: isEditing ? ButtonType.primary : ButtonType.error,
                style: isEditing ? CustomStyle.filled : CustomStyle.outlined,
                onTap: () async {
                  if (state.isLoading) return;

                  if (isEditing) {
                    if (nameError || emailError || ageError) {
                      CustomSnackBar.show(
                        context,
                        backgroundColor: theme.colorScheme.error,
                        message: lang.pleaseFillAllTheFieldsWithValidData,
                      );
                      return;
                    }

                    final age = _ageController.text.trim().isEmpty
                        ? null
                        : int.tryParse(_ageController.text.trim());

                    final viewModel = ref.read(
                      myInformationViewModelProvider.notifier,
                    );
                    final isValid = await viewModel.updateUserData(
                      User(
                        id: state.user?.id,
                        email: _emailController.text.trim(),
                        name: _nameController.text.trim(),
                        age: age,
                        lang: _selectedLang,
                      ),
                    );

                    if (context.mounted) {
                      if (isValid) {
                        setState(() {
                          isEditing = false;
                        });
                        CustomSnackBar.show(
                          context,
                          backgroundColor: theme.colorScheme.primary,
                          message: lang.informationUpdatedSuccessfully,
                        );
                      } else {
                        CustomSnackBar.show(
                          context,
                          backgroundColor: theme.colorScheme.error,
                          message: lang.errorUpdatingInformation,
                        );
                      }
                    }
                  } else {
                    showDeleteAccountDialog();
                  }
                },
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  AppIcons.arrowLeftIcon,
                  height: AppSizes.iconSizeXLarge,
                  width: AppSizes.iconSizeXLarge,
                  colorFilter: ColorFilter.mode(
                    theme.primaryIconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showDeleteAccountDialog() {
    final lang = S.of(context);
    final theme = Theme.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.deleteAccount,
      content: lang.afterDeletingYourAccountYouWillLoseAllYourData,
      iconPath: AppIcons.sadPetImage,
      buttonTitle: lang.deleteAccount,
      buttonType: ButtonType.error,
      onPrimaryTap: () async {
        final viewModel = ref.read(myInformationViewModelProvider.notifier);
        final result = await viewModel.deleteAccount();

        if (context.mounted) {
          if (result) {
            if (context.mounted) {
              context.go(Routes.initialPath);
            }
          } else {
            CustomSnackBar.show(
              context,
              backgroundColor: theme.colorScheme.error,
              message: lang.errorDeletingAccount,
            );
          }
        }
      },
    );
  }
}

