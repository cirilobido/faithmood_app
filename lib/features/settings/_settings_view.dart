import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/core_exports.dart';
import '../../features/home/_home_view_model.dart';
import '../../features/profile/_profile_view_model.dart';
import '../../generated/l10n.dart';
import '../../routes/app_routes_names.dart';
import '../../widgets/widgets_exports.dart';
import '_settings_view_model.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsViewModelProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final state = ref.watch(settingsViewModelProvider);
    final settings = viewModel.settings;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: SafeArea(
          child: Column(
            children: [
              Text(lang.settings, style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSizes.spacingSmall),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.isPremium == false)
                        const SizedBox(height: AppSizes.spacingSmall),
                      if (state.isPremium == false) _buildPremiumBanner(lang, theme),
                      if (state.isPremium == false)
                        const SizedBox(height: AppSizes.spacingMedium),
                      _buildSection(
                        title: lang.account,
                        items: [
                          SettingItem(
                            lang.personalInformation,
                            AppIcons.userIcon,
                            onTap: () {
                              context.push(Routes.myInformation);
                            },
                          ),
                          SettingItem(
                            lang.privacySecurity,
                            AppIcons.safeBoxIcon,
                            onTap: () {
                              context.push(Routes.privacyAndSecurity);
                            },
                          ),
                          SettingItem(
                            lang.currentSubscription,
                            subtitle: (state.isPremium ?? false) ? lang.premium : lang.user,
                            AppIcons.diamondIcon,
                            showArrow: false,
                          ),
                        ],
                      ),
                      _buildSection(
                        title: lang.customization,
                        items: [
                          SettingItem(
                            lang.reminderAlert,
                            AppIcons.bellIcon,
                            onTap: () async {
                              context.push(Routes.reminder);
                            },
                          ),
                          SettingItem(
                            lang.appLanguage,
                            subtitle: lang.localeName,
                            AppIcons.langIcon,
                            onTap: () async {
                              final langProvider = ref.watch(
                                appLanguageProvider,
                              );
                              final currentLocale = langProvider.currentLocale;
                              final selectedLang = Lang.values.firstWhere(
                                (lang) => lang.name == currentLocale.languageCode,
                                orElse: () => Lang.en,
                              );

                              await LanguageBottomSheet.show(
                                context: context,
                                selectedLang: selectedLang,
                                onChanged: (value) {
                                  if (value != null) {
                                    langProvider.changeLocale(
                                      Locale(value.name),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          SettingItem(
                            lang.appTheme,
                            subtitle: _getThemeModeSubtitle(lang, ref.watch(appThemeProvider).themeMode),
                            AppIcons.settingsIcon,
                            onTap: () async {
                              final themeProvider = ref.watch(appThemeProvider);
                              final currentThemeMode = themeProvider.themeMode;

                              await ThemeModeBottomSheet.show(
                                context: context,
                                selectedThemeMode: currentThemeMode,
                                onChanged: (value) {
                                  if (value != null) {
                                    themeProvider.setThemeMode(value);
                                  }
                                },
                              );
                            },
                          ),
                          SettingItem(
                            lang.vibration,
                            AppIcons.vibrationIcon,
                            showArrow: false,
                            isSwitch: true,
                            switchValue: ref.watch(hapticFeedbackProvider).isEnabled,
                            onSwitchChanged: (value) {
                              ref
                                  .read(hapticFeedbackProvider)
                                  .setEnabled(value);
                              triggerHapticFeedback(
                                HapticsType.error,
                                context: context,
                              );
                            },
                          ),
                        ],
                      ),
                      _buildSection(
                        title: lang.ourApp,
                        items: [
                          SettingItem(
                            lang.rateUs,
                            AppIcons.starIcon,
                            showArrow: false,
                            onTap: () {
                              viewModel.rateApp();
                            },
                          ),
                          SettingItem(
                            lang.shareApp,
                            AppIcons.shareIcon,
                            showArrow: false,
                            onTap: () {
                              if (settings?.shareUrl != null) {
                                SharePlus.instance.share(
                                  ShareParams(
                                    title: lang.shareFaithMoodApp,
                                    text: lang.shareFaithMoodAppMessage.replaceAll('###', settings!.shareUrl!),
                                  ),
                                );
                              }
                            },
                          ),
                          SettingItem(
                            lang.followUs,
                            AppIcons.thumbsUpIcon,
                            showArrow: false,
                            onTap: () {
                              if (settings?.followUrl != null) {
                                viewModel.launchAppUrl(settings!.followUrl!);
                              }
                            },
                          ),
                        ],
                      ),
                      _buildSection(
                        title: lang.support,
                        items: [
                          SettingItem(
                            lang.contactUs,
                            AppIcons.emailIcon,
                            showArrow: false,
                            onTap: () {
                              if (settings?.supportUrl != null) {
                                viewModel.launchAppUrl(settings!.supportUrl!);
                              }
                            },
                          ),
                          SettingItem(
                            lang.privacyPolicy,
                            AppIcons.shieldCheckIcon,
                            showArrow: false,
                            onTap: () {
                              if (settings?.privacyUrl != null) {
                                viewModel.launchAppUrl(settings!.privacyUrl!);
                              }
                            },
                          ),
                          SettingItem(
                            lang.termsConditions,
                            AppIcons.handshakeIcon,
                            showArrow: false,
                            onTap: () {
                              if (settings?.termsUrl != null) {
                                viewModel.launchAppUrl(settings!.termsUrl!);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),
                      CustomButton(
                        title: lang.logOut,
                        type: ButtonType.error,
                        onTap: showLogOutDialog,
                      ),
                      const SizedBox(height: AppSizes.spacingSmall),
                      Center(
                        child: Text(
                          lang.appVersionStateappversion.replaceAll('###', state.appVersion ?? ''),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.textTheme.labelSmall?.color!,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingLarge),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  AppIcons.closeIcon,
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

  Widget _buildPremiumBanner(S lang, ThemeData theme) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        context.push(Routes.subscription, extra: PaywallEnum.settingsPlacement);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          gradient: AppColors.gradientPremium,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Text(
          lang.unlockPremiumFeatures,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<SettingItem> items,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.labelSmall?.color!,
            ),
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          ...items.map(
            (e) => _CardItem(
              title: e.title,
              subtitle: e.subtitle,
              icon: e.icon,
              onTap: e.onTap ?? () {},
              showArrow: e.showArrow,
              isSwitch: e.isSwitch,
              switchValue: e.switchValue,
              onSwitchChanged: e.onSwitchChanged,
            ),
          ),
        ],
      ),
    );
  }

  void showLogOutDialog() {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      title: lang.logOut,
      content: lang.areYouSureYouWantToLogOut,
      iconPath: AppIcons.sadPetImage,
      buttonTitle: lang.logOut,
      onPrimaryTap: () async {
        // Close the confirmation dialog first
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        
        // Show loading dialog
        if (context.mounted) {
          LoadingDialog.show(context: context, message: lang.logOut);
        }
        
        final viewModel = ref.read(settingsViewModelProvider.notifier);
        final result = await viewModel.logOut();

        // Hide loading dialog
        if (context.mounted) {
          LoadingDialog.hide(context);
        }

        if (result && context.mounted) {
          ref.invalidate(homeViewModelProvider);
          ref.invalidate(profileViewModelProvider);
          context.go(Routes.initialPath);
        }
      },
    );
  }

  String _getThemeModeSubtitle(S lang, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return lang.light;
      case ThemeMode.dark:
        return lang.dark;
      case ThemeMode.system:
        return lang.system;
    }
  }
}

class SettingItem {
  final String title;
  final String? subtitle;
  final String icon;
  final bool showArrow;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  SettingItem(
    this.title,
    this.icon, {
    this.subtitle,
    this.onTap,
    this.showArrow = true,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
  });
}

class _CardItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String icon;
  final VoidCallback onTap;
  final bool showArrow;
  final bool isSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const _CardItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.showArrow = true,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.paddingSmall,
        bottom: AppSizes.paddingMedium,
        left: AppSizes.paddingSmall,
        right: AppSizes.paddingSmall,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: AppSizes.iconSizeMedium,
              width: AppSizes.iconSizeMedium,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSizes.spacingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color!,
                      ),
                    ),
                ],
              ),
            ),
            if (isSwitch && switchValue != null && onSwitchChanged != null)
              Switch(
                activeColor: theme.colorScheme.onSurface,
                activeTrackColor: theme.colorScheme.primary,
                inactiveTrackColor: theme.colorScheme.onSurface,
                inactiveThumbColor: theme.colorScheme.primary,
                trackOutlineWidth: WidgetStatePropertyAll(AppSizes.borderWithSmall),
                value: switchValue!,
                onChanged: onSwitchChanged,
              )
            else if (showArrow)
              SvgPicture.asset(
                AppIcons.arrowRightIcon,
                height: AppSizes.iconSizeRegular,
                width: AppSizes.iconSizeRegular,
                colorFilter: ColorFilter.mode(
                  theme.primaryIconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

