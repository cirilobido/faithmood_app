import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_exports.dart';
import '../../routes/app_routes_names.dart';
import '../../generated/l10n.dart';
import '../../widgets/widgets_exports.dart';
import '_forgot_password_view_model.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  final String? email;

  const ForgotPasswordView({super.key, this.email});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  late final currentEmail = widget.email ?? '';

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  bool otpError = false;

  final TextEditingController _passController = TextEditingController();
  final FocusNode _passFocusNode = FocusNode();
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  bool _isOtpComplete() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final state = ref.watch(forgotPasswordViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppSizes.paddingLarge),
                    child: Image.asset(
                      AppIcons.appLogo,
                      height: AppSizes.logoIconSize,
                    ),
                  ),
                  Expanded(child: _otpAndPassContent()),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLarge,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 2,
                          child: CustomButton(
                            title: lang.back,
                            type: ButtonType.tertiary,
                            style: CustomStyle.outlined,
                            onTap: () {
                              if (context.mounted) {
                                context.go(Routes.login);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: AppSizes.spacingSmall),
                        Flexible(
                          flex: 3,
                          child: CustomButton(
                            isLoading: state.isLoading,
                            title: lang.continueText,
                            type: ButtonType.primary,
                            onTap: () {
                              _handleVerifyOtp();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleVerifyOtp() async {
    final state = ref.watch(forgotPasswordViewModelProvider);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || state.isLoading) {
      return;
    }

    if (!_isOtpComplete()) {
      setState(() {
        otpError = true;
      });
      return;
    }

    final viewModel = ref.read(forgotPasswordViewModelProvider.notifier);
    final success = await viewModel.verifyOtp(
      AuthRequest(
        email: currentEmail,
        otpCode: _getOtpCode(),
        newPassword: _passController.text.trim(),
      ),
    );
    if (success && context.mounted) {
      showVerifyOtpSuccessDialog();
      return;
    }
    showErrorDialog();
  }

  void showVerifyOtpSuccessDialog() {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.passwordRestored,
      content: lang.passwordRestoredSuccessfully,
      buttonTitle: lang.signInNow,
      onPrimaryTap: () async {
        context.go(Routes.login);
      },
    );
  }

  void showErrorDialog() {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.verificationFailed,
      content: lang.verificationFailedMessage,
      buttonTitle: lang.tryAgain,
      onPrimaryTap: () async {
        _handleVerifyOtp();
      },
    );
  }

  Widget _otpAndPassContent() {
    final theme = Theme.of(context);
    final lang = S.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang.verifyCode, style: theme.textTheme.displaySmall),
              const SizedBox(height: AppSizes.spacingMedium),
              Text(lang.verifyCodeMessage, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSizes.spacingLarge),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: lang.otpCode,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: AppSizes.spacingXXSmall,
                          ),
                          child: InputField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 1,
                            onChanged: (value) {
                              setState(() {
                                otpError = false;
                              });

                              if (value.isNotEmpty) {
                                if (index < 5) {
                                  _otpFocusNodes[index + 1].requestFocus();
                                } else {
                                  _otpFocusNodes[index].unfocus();
                                }
                              }
                            },
                            onTap: () {
                              if (_otpControllers[index].text.isNotEmpty) {
                                _otpControllers[index].selection =
                                    TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _otpControllers[index].text.length,
                                    );
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  if (otpError)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSizes.spacingSmall,
                        left: AppSizes.paddingSmall,
                      ),
                      child: Text(
                        lang.thisFieldIsRequired,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppSizes.spacingLarge),
              InputField(
                hintText: '*********',
                label: lang.password,
                controller: _passController,
                focusNode: _passFocusNode,
                validations: [FieldTypeValidation.password],
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
              InkWell(
                onTap: () {
                  showSendOtpDialog();
                },
                child: Text(
                  lang.resendCode,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSendOtpDialog() async {
    final state = ref.watch(forgotPasswordViewModelProvider);
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
        if (!_isOtpComplete()) {
          setState(() {
            otpError = true;
          });
          return;
        }
        final viewModel = ref.read(forgotPasswordViewModelProvider.notifier);
        otpSent = await viewModel.sendOtp(AuthRequest(email: _getOtpCode()));
      },
    );
    if (!otpSent && state.isLoading) {
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
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    _passController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }
}
