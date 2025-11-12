// 🐦 Flutter imports:
import 'dart:async';
import 'dart:io';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart';
import '../../core/core_exports.dart';
import '../../routes/app_routes_names.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '../../widgets/widgets_exports.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _init();
    });
  }

  Future<void> _init() async {
    final appSettingProvider = ref.read(settingsProvider);
    try {
      await appSettingProvider.getSetting();
      final appSetting = appSettingProvider.settings;
      final serverVersion = Version.parse(appSetting?.appVersion ?? '0.0.1');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final appVersion = Version.parse(packageInfo.version);
      if (appVersion < serverVersion) {
        final updateUrl = Platform.isAndroid
            ? appSetting?.appUpdateUrlAndroid
            : appSetting?.appUpdateUrlIos;
        showUpdateAppDialog(storeUrl: updateUrl ?? appSetting?.aboutUrl ?? '');
        return;
      }
    } catch (e) {
      final analytics = ref.read(firebaseAnalyticProvider);
      analytics.logEvent(
        name: 'error_getting_settings',
        parameters: {'screen': 'splash_screen', 'error': e.toString()},
      );
      devLogger('Error SplashView: $e');
    }

    final isUserFirstTimeOpen = await appSettingProvider.getIsFirstTimeOpen();
    if (mounted && isUserFirstTimeOpen) {
      context.go(Routes.welcome);
      return;
    }
    final isUserLoggedIn = await appSettingProvider.getIsUserLoggedIn();
    if (mounted && isUserLoggedIn) {
      final auth = ref.read(authProvider);
      await auth.refreshUserInformation();
      final user = auth.user;
      if (user != null) {
        context.go(Routes.home);
        return;
      }
      final analytics = ref.read(firebaseAnalyticProvider);
      analytics.logEvent(
        name: 'error_refreshing_user',
        parameters: {'screen': 'splash_screen', 'error': 'User not found'},
      );
    }
    if (mounted) {
      context.go(Routes.login);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Center(
              child: Image.asset(
                AppIcons.splashGradientImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Image.asset(AppIcons.appLogo, width: screenWidth * 0.2),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: SizedBox(
              width: AppSizes.iconSizeMedium,
              height: AppSizes.iconSizeMedium,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showUpdateAppDialog({required String storeUrl}) {
    final lang = S.of(context);
    CustomDialogModal.show(
      context: context,
      dismissible: false,
      title: lang.updateAvailable,
      content: lang.updateAvailableMessage,
      buttonTitle: lang.update,
      onPrimaryTap: () async {
        if (await canLaunchUrl(Uri.parse(storeUrl))) {
          await launchUrl(
            Uri.parse(storeUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      },
    );
  }
}
