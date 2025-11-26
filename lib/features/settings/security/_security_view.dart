import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '_security_view_model.dart';

class SecurityView extends ConsumerStatefulWidget {
  const SecurityView({super.key});

  @override
  ConsumerState<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends ConsumerState<SecurityView> {
  late bool isEditing = false;
  final TextEditingController _passwordController = TextEditingController();
  bool passwordError = false;
  final TextEditingController _newPasswordController = TextEditingController();
  bool newPasswordError = false;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _confirmationAccepted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(securityViewModelProvider.notifier).loadData();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _passwordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final state = ref.watch(securityViewModelProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      lang.privacySecurity,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => setState(() {
                      passwordError = false;
                      newPasswordError = false;
                      _passwordController.text = '';
                      _newPasswordController.text = '';
                      _passwordFocusNode.unfocus();
                      _newPasswordFocusNode.unfocus();
                      isEditing = !isEditing;
                    }),
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
              const SizedBox(height: AppSizes.spacingMedium),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSizes.spacingMedium),
                        InputField(
                          required: isEditing,
                          readOnly: !isEditing,
                          label: lang.password,
                          hintText: lang.neverStored,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: !_showPassword,
                          prefixIconWidget: SvgPicture.asset(
                            AppIcons.keyIcon,
                            colorFilter: ColorFilter.mode(
                              theme.iconTheme.color!,
                              BlendMode.srcIn,
                            ),
                          ),
                          suffixIconWidget: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: SvgPicture.asset(
                              _showPassword
                                  ? AppIcons.eyeIcon
                                  : AppIcons.eyeClosedIcon,
                              colorFilter: ColorFilter.mode(
                                _showPassword
                                    ? theme.colorScheme.secondary
                                    : theme.iconTheme.color!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validations: [FieldTypeValidation.password],
                          onChanged: (value) {
                            setState(() {
                              passwordError =
                                  InputValidations.validatePassword(
                                    context,
                                    value,
                                  ) !=
                                  null;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.spacingLarge),
                        if (isEditing)
                          InputField(
                            required: true,
                            label: lang.newPassword,
                            hintText: lang.appName,
                            controller: _newPasswordController,
                            focusNode: _newPasswordFocusNode,
                            obscureText: !_showNewPassword,
                            prefixIconWidget: SvgPicture.asset(
                              AppIcons.keyIcon,
                              colorFilter: ColorFilter.mode(
                                theme.iconTheme.color!,
                                BlendMode.srcIn,
                              ),
                            ),
                            suffixIconWidget: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showNewPassword = !_showNewPassword;
                                });
                              },
                              icon: SvgPicture.asset(
                                _showNewPassword
                                    ? AppIcons.eyeIcon
                                    : AppIcons.eyeClosedIcon,
                                colorFilter: ColorFilter.mode(
                                  _showNewPassword
                                      ? theme.colorScheme.secondary
                                      : theme.iconTheme.color!,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            validations: [FieldTypeValidation.password],
                            onChanged: (value) {
                              setState(() {
                                newPasswordError =
                                    InputValidations.validatePassword(
                                      context,
                                      value,
                                    ) !=
                                    null;
                              });
                            },
                          ),
                        if (isEditing)
                          const SizedBox(height: AppSizes.spacingLarge),
                        if (isEditing)
                          ListTileTheme(
                            horizontalTitleGap: 4,
                            child: CheckboxListTile(
                              checkboxScaleFactor: 1.1,
                              value: _confirmationAccepted,
                              onChanged: (value) => setState(() {
                                _confirmationAccepted = value ?? false;
                              }),
                              title: Text(
                                 lang.iAgreeToChangeMyPassword,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: _confirmationAccepted
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return theme.colorScheme.primary;
                                  }
                                  return theme.colorScheme.onSurface;
                                },
                              ),
                              activeColor: theme.colorScheme.secondary,
                              checkColor: theme.colorScheme.onSurface,
                              side: BorderSide(
                                color: theme.colorScheme.outline,
                                width: AppSizes.borderWithSmall,
                              ),
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusXXSmall,
                                ),
                              ),
                              visualDensity: const VisualDensity(
                                horizontal: -1,
                                vertical: -2,
                              ),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        const SizedBox(height: AppSizes.spacingLarge),
                        RichText(
                          text: TextSpan(
                            text: '${lang.yourPasswordIs} ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.labelSmall?.color,
                            ),
                            children: [
                              TextSpan(
                                text: '${lang.neverStored} ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text: lang.inTheApp,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.labelSmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingMedium),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              if (isEditing)
                CustomButton(
                  isLoading: state.isLoading,
                  title: lang.updateInformation,
                  type: ButtonType.secondary,
                  style: CustomStyle.filled,
                  onTap: () async {
                    if (state.isLoading) return;

                    final lang = S.of(context);

                    if (!_confirmationAccepted) {
                      CustomSnackBar.show(
                        context,
                        backgroundColor: theme.colorScheme.error,
                        message: lang.iAgreeToChangeMyPassword,
                      );
                      return;
                    }

                    passwordError =
                        InputValidations.validatePassword(
                          context,
                          _passwordController.text,
                        ) !=
                        null;

                    newPasswordError =
                        InputValidations.validatePassword(
                          context,
                          _newPasswordController.text,
                        ) !=
                        null;

                    if (passwordError || newPasswordError) {
                      CustomSnackBar.show(
                        context,
                        backgroundColor: theme.colorScheme.error,
                        message: lang.pleaseFillAllTheFieldsWithValidData,
                      );
                      return;
                    }

                    if (context.mounted) {
                      LoadingDialog.show(
                        context: context,
                        message: lang.updateInformation,
                      );
                    }

                    final viewModel = ref.read(
                      securityViewModelProvider.notifier,
                    );

                    final user = state.user ?? User();
                    final userWithPassword = User(
                      id: user.id,
                    );
                    (userWithPassword as dynamic).password = _passwordController.text;
                    (userWithPassword as dynamic).newPassword = _newPasswordController.text;
                    
                    final isValid = await viewModel.changePassword(
                      userWithPassword,
                    );

                    if (context.mounted) {
                      LoadingDialog.hide(context);
                      
                      if (isValid) {
                        setState(() {
                          isEditing = false;
                          _passwordController.text = '';
                          _newPasswordController.text = '';
                          _confirmationAccepted = false;
                        });
                        CustomSnackBar.show(
                          context,
                          backgroundColor: theme.colorScheme.primary,
                          message: lang.informationUpdatedSuccessfully,
                        );
                      } else {
                        showUpdateInformationErrorDialog();
                      }
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

  void showUpdateInformationErrorDialog() {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.updateInformation,
      content:
          lang.sorrySomethingWentWrongWhileUpdatingYourInformationPleaseTry,
      iconPath: AppIcons.sadPetImage,
      buttonTitle: lang.continueText,
      buttonType: ButtonType.primary,
      onPrimaryTap: () async {},
    );
  }
}

