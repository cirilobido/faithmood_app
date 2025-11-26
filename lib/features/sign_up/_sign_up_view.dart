import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core_exports.dart';
import '../../routes/app_routes_names.dart';
import '../../generated/l10n.dart';
import '../../widgets/widgets_exports.dart';
import '_sign_up_view_model.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  String? privacyUrl;
  String? termsUrl;

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool emailError = false;
  final TextEditingController _passController = TextEditingController();
  final FocusNode _passFocusNode = FocusNode();
  bool passError = false;
  bool _showPassword = false;
  final TextEditingController _passConfirmController = TextEditingController();
  final FocusNode _passConfirmFocusNode = FocusNode();
  bool passConfirmError = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    final appSettingProvider = ref.read(settingsProvider);
    final appSetting = appSettingProvider.settings;
    privacyUrl = appSetting?.privacyUrl;
    termsUrl = appSetting?.termsUrl;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final state = ref.watch(signUpViewModelProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.paddingMedium,
                  left: AppSizes.paddingMedium,
                  right: AppSizes.paddingMedium,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppSizes.iconSizeMedium,
                      height: AppSizes.iconSizeMedium,
                    ),
                    InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: SvgPicture.asset(
                        AppIcons.closeIcon,
                        width: AppSizes.iconSizeMedium,
                        height: AppSizes.iconSizeMedium,
                        colorFilter: ColorFilter.mode(
                          theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _mailAndPassContent(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      isLoading: state.isLoading,
                      title: lang.continueText,
                      onTap: _handleNextPage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNextPage() async {
    final theme = Theme.of(context);
    final lang = S.of(context);
      if (_passController.text != _passConfirmController.text) {
        setState(() {
          passError = true;
          passConfirmError = true;
        });
        CustomSnackBar.show(
          context,
          backgroundColor: theme.colorScheme.error,
          message: lang.passwordDontMatch,
        );
        return;
      }
      setState(() {
        emailError =
            InputValidations.validateEmail(context, _emailController.text) !=
            null;
        passError =
            InputValidations.validatePassword(context, _passController.text) !=
            null;
        passConfirmError =
            InputValidations.validatePassword(
              context,
              _passConfirmController.text,
            ) !=
            null;
      });
      if (emailError || passError || passConfirmError) {
        final lang = S.of(context);
        CustomSnackBar.show(
          context,
          backgroundColor: theme.colorScheme.error,
          message: lang.invalidEmailOrPasswordPleaseTryAgain,
        );
        return;
      }
      _emailFocusNode.unfocus();
      _passFocusNode.unfocus();
      _passConfirmFocusNode.unfocus();
      _handleRegisterUser();
      return;
  }

  _handleRegisterUser() async {
    if (_emailController.text.trim().isEmpty ||
        _passController.text.trim().isEmpty ||
        _passConfirmController.text.trim().isEmpty) {
      return;
    }
    
    if (context.mounted) {
      LoadingDialog.show(
        context: context,
        message: S.of(context).saving,
      );
    }
    
    final viewModel = ref.read(signUpViewModelProvider.notifier);
    final success = await viewModel.registerUser(
      AuthRequest(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
        newPassword: _passConfirmController.text.trim(),
      ),
    );
    
    if (context.mounted) {
      LoadingDialog.hide(context);
      
      if (success) {
        context.go(Routes.home);
        return;
      }
      showErrorDialog();
    }
  }

  void showErrorDialog() {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.sorryAboutThis,
      content: lang.registrationErrorMessage,
      buttonTitle: lang.tryAgain,
      onPrimaryTap: () async {},
    );
  }

  Widget _mailAndPassContent() {
    final theme = Theme.of(context);
    final lang = S.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.emailPassword, style: theme.textTheme.headlineLarge),
            Text(
              lang.signUpEmailMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.labelSmall?.color!,
              ),
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            InputField(
              required: true,
              hintText: 'user@gmail.com',
              label: lang.email,
              controller: _emailController,
              focusNode: _emailFocusNode,
              prefixIconWidget: SvgPicture.asset(
                AppIcons.emailIcon,
                colorFilter: ColorFilter.mode(theme.primaryIconTheme.color!, BlendMode.srcIn),
              ),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validations: [FieldTypeValidation.email],
              onChanged: (value) {
                setState(() {
                  emailError =
                      InputValidations.validateEmail(context, value) != null;
                });
              },
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            InputField(
              required: true,
              hintText: '---------',
              label: lang.password,
              controller: _passController,
              focusNode: _passFocusNode,
              obscureText: !_showPassword,
              prefixIconWidget: SvgPicture.asset(
                AppIcons.keyIcon,
                colorFilter: ColorFilter.mode(theme.primaryIconTheme.color!, BlendMode.srcIn),
              ),
              suffixIconWidget: IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: SvgPicture.asset(
                  _showPassword ? AppIcons.eyeIcon : AppIcons.eyeClosedIcon,
                  colorFilter: ColorFilter.mode(
                    _showPassword ? theme.colorScheme.primary : theme.primaryIconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validations: [FieldTypeValidation.password],
              onChanged: (value) {
                setState(() {
                  passError =
                      InputValidations.validatePassword(context, value) != null;
                });
              },
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            InputField(
              required: true,
              hintText: '---------',
              label: lang.confirmPassword,
              controller: _passConfirmController,
              focusNode: _passConfirmFocusNode,
              obscureText: !_showConfirmPassword,
              prefixIconWidget: SvgPicture.asset(
                AppIcons.keyIcon,
                colorFilter: ColorFilter.mode(theme.primaryIconTheme.color!, BlendMode.srcIn),
              ),
              suffixIconWidget: IconButton(
                onPressed: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
                icon: SvgPicture.asset(
                  _showConfirmPassword
                      ? AppIcons.eyeIcon
                      : AppIcons.eyeClosedIcon,
                  colorFilter: ColorFilter.mode(
                    _showConfirmPassword
                        ? theme.colorScheme.primary
                        : theme.primaryIconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validations: [FieldTypeValidation.password],
              onChanged: (value) {
                setState(() {
                  passConfirmError =
                      InputValidations.validatePassword(context, value) != null;
                });
              },
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            RichText(
              text: TextSpan(
                text: "${lang.privacyText1} ",
                style: theme.textTheme.bodySmall,
                children: [
                  WidgetSpan(
                    child: _linkText(lang.privacyPolicy, privacyUrl),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(text: " ${lang.and} "),
                  WidgetSpan(
                    child: _linkText(lang.termsOfUse, termsUrl),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(text: " ${lang.informationSafeMessage}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkText(String text, String? url) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        if (url != null) launchUrl(Uri.parse(url));
      },
      child: Text(
        text,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _passConfirmController.dispose();

    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _passConfirmFocusNode.dispose();

    super.dispose();
  }
}
