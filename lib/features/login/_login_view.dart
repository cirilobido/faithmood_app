import 'package:faithmood_app/dev_utils/_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_exports.dart';
import '../../routes/app_routes_names.dart';
import '../../generated/l10n.dart';
import '../../widgets/widgets_exports.dart';
import '_login_view_model.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  // TODO: EMAIL AND PASS FOR TESTING
  final TextEditingController _emailController = TextEditingController(text: 'testaccount@example.com');
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _passController = TextEditingController(text: '@Rnd0121');
  final FocusNode _passFocusNode = FocusNode();
  bool _showPassword = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final state = ref.watch(loginViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
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
                child: Image.asset(
                  AppIcons.logoSecondary,
                  height: AppSizes.iconSizeLarge,
                ),
              ),
              Expanded(child: _mailAndPassContent()),
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
                      title: lang.signIn,
                      type: ButtonType.primary,
                      onTap: () {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (isValid) {
                          _handleLoginUser();
                          return;
                        }
                        CustomSnackBar.show(
                          context,
                          backgroundColor: AppColors.error,
                          message: lang.invalidEmailOrPasswordPleaseTryAgain,
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.spacingSmall),
                    CustomButton(
                      title: lang.createAnAccount,
                      type: ButtonType.secondary,
                      style: CustomStyle.borderless,
                      onTap: () {
                        if (context.mounted) {
                          context.go(Routes.signUp);
                        }
                      },
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

  Widget _mailAndPassContent() {
    final theme = Theme.of(context);
    final lang = S.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang.emailPassword, style: theme.textTheme.displaySmall),
              Text(
                S.of(context).loginGreetingMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              InputField(
                required: true,
                hintText: 'user@gmail.com',
                label: lang.email,
                controller: _emailController,
                focusNode: _emailFocusNode,
                prefixIconWidget: SvgPicture.asset(
                  AppIcons.emailIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validations: [FieldTypeValidation.email],
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              InputField(
                required: true,
                hintText: '---------',
                label: lang.password,
                controller: _passController,
                focusNode: _passFocusNode,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                obscureText: !_showPassword,
                prefixIconWidget: SvgPicture.asset(
                  AppIcons.keyIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.iconPrimary,
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
                    _showPassword ? AppIcons.eyeIcon : AppIcons.eyeClosedIcon,
                    colorFilter: ColorFilter.mode(
                      _showPassword
                          ? theme.colorScheme.secondary
                          : AppColors.iconPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    final isValid =
                        InputValidations.validateEmail(
                          context,
                          _emailController.text,
                        ) ==
                        null;
                    if (isValid) {
                      showForgotPasswordDialog();
                      return;
                    }
                    CustomSnackBar.show(
                      context,
                      backgroundColor: AppColors.error,
                      message: lang.youHaveToEnterAValidEmail,
                    );
                  },
                  child: Text(
                    lang.forgotYourPassword,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingXXLarge),
              Center(
                child: Text(
                  lang.orLoginWith,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleIconCard(
                    iconPath: AppIcons.googleIcon,
                    onTap: () => devLogger('Google tapped'),
                  ),
                  const SizedBox(width: AppSizes.spacingLarge),
                  CircleIconCard(
                    iconPath: AppIcons.facebookIcon,
                    onTap: () => devLogger('Facebook tapped'),
                  ),
                  const SizedBox(width: AppSizes.spacingLarge),
                  CircleIconCard(
                    iconPath: AppIcons.appleIcon,
                    onTap: () => devLogger('Apple tapped'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleLoginUser() async {
    _emailFocusNode.unfocus();
    _passFocusNode.unfocus();
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final success = await viewModel.loginUser(
      AuthRequest(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      ),
    );
    if (success && context.mounted) {
      context.push(Routes.home);
      return;
    }
    showErrorDialog();
  }

  void showErrorDialog() {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.sorryAboutThis,
      content: lang.loginErrorMessage,
      buttonTitle: lang.tryAgain,
      onPrimaryTap: () async {},
    );
  }

  void showForgotPasswordDialog() async {
    final state = ref.watch(loginViewModelProvider);
    final lang = S.of(context);
    bool otpSent = false;
    await CustomDialogModal.show(
      context: context,
      title: lang.resetPassword,
      content: lang.weWillSendYouAnEmailWithACodeTo,
      iconPath: AppIcons.shieldCheckImage,
      buttonTitle: lang.continueText,
      onPrimaryTap: () async {
        if (state.isLoading) {
          return;
        }
        final email = _emailController.text.trim();
        final viewModel = ref.read(loginViewModelProvider.notifier);
        otpSent = await viewModel.sendOtp(AuthRequest(email: email));
      },
    );
    if (otpSent) {
      context.go(
        Routes.forgotPassword,
        extra: {'email': _emailController.text},
      );
    } else if (state.isLoading) {
      showSendOtpErrorDialog();
    }
  }

  void showSendOtpErrorDialog() {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.sorryAboutThis,
      content: lang.somethingWentWrongWhileSendingTheOtpCodePleaseTry,
      iconPath: AppIcons.errorImage,
      buttonTitle: lang.tryAgain,
      onPrimaryTap: () async {},
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }
}
