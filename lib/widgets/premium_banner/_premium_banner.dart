import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../../routes/app_routes_names.dart';
import '../../core/providers/domain/use_cases/review_use_case.dart';
import '../../core/providers/_auth_provider.dart' as auth_prov;

class PremiumBanner extends ConsumerStatefulWidget {
  const PremiumBanner({super.key});

  @override
  ConsumerState<PremiumBanner> createState() => _PremiumBannerState();
}

class PremiumBannerConditional extends ConsumerStatefulWidget {
  const PremiumBannerConditional({super.key});

  @override
  ConsumerState<PremiumBannerConditional> createState() =>
      _PremiumBannerConditionalState();
}

class _PremiumBannerConditionalState
    extends ConsumerState<PremiumBannerConditional> {
  bool _shouldShow = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkShouldShow();
    });
  }

  Future<void> _checkShouldShow() async {
    final auth = ref.read(auth_prov.authProvider);
    final reviewUseCase = ref.read(reviewUseCaseProvider);

    final isPremium = auth.user?.planType == PlanName.PREMIUM;
    if (isPremium) {
      if (mounted) {
        setState(() {
          _shouldShow = false;
          _isLoading = false;
        });
      }
      return;
    }

    final dismissedResult = await reviewUseCase.getPremiumBannerDismissed();
    bool isDismissed = false;
    switch (dismissedResult) {
      case Success(value: final value):
        isDismissed = value;
      case Failure():
        break;
    }
    if (isDismissed) {
      if (mounted) {
        setState(() {
          _shouldShow = false;
          _isLoading = false;
        });
      }
      return;
    }

    final installationDateResult = await reviewUseCase.getAppInstallationDate();
    DateTime? installationDate;
    switch (installationDateResult) {
      case Success(value: final value):
        installationDate = value;
      case Failure():
        break;
    }

    if (installationDate == null) {
      final now = DateTime.now();
      await reviewUseCase.saveAppInstallationDate(now);
      if (mounted) {
        setState(() {
          _shouldShow = false;
          _isLoading = false;
        });
      }
      return;
    }

    final daysSinceInstall = DateTime.now().difference(installationDate).inDays;
    if (mounted) {
      setState(() {
        _shouldShow = daysSinceInstall >= 1;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || !_shouldShow) return const SizedBox.shrink();
    return PremiumBanner();
  }
}

class _PremiumBannerState extends ConsumerState<PremiumBanner> {
  bool _isDismissed = false;
  bool _isLoading = true;
  String? _bannerText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDismissalState();
    });
  }

  String _getRandomBannerText(S lang) {
    final texts = [
      lang.premiumBanner1,
      lang.premiumBanner2,
      lang.premiumBanner3,
      lang.premiumBanner4,
      lang.premiumBanner5,
    ];
    final index = DateTime.now().day % texts.length;
    return texts[index];
  }

  Future<void> _checkDismissalState() async {
    final reviewUseCase = ref.read(reviewUseCaseProvider);
    final result = await reviewUseCase.getPremiumBannerDismissed();

    switch (result) {
      case Success(value: final value):
        if (mounted) {
          setState(() {
            _isDismissed = value;
            _isLoading = false;
          });
        }
      case Failure():
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
    }
  }

  Future<void> _dismissBanner() async {
    final reviewUseCase = ref.read(reviewUseCaseProvider);
    final result = await reviewUseCase.setPremiumBannerDismissed(true);

    switch (result) {
      case Success():
        if (mounted) {
          setState(() {
            _isDismissed = true;
          });
        }
      case Failure():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isDismissed) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final lang = S.of(context);
    
    if (_bannerText == null) {
      _bannerText = _getRandomBannerText(lang);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
      child: InkWell(
        onTap: () {
          context.push(Routes.subscription);
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingSmall,
            vertical: AppSizes.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.dCardPrimary,
            border: Border.all(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
              width: AppSizes.borderWithSmall,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Row(
            children: [
              SizedBox(
                width: AppSizes.iconSizeNormal,
                height: AppSizes.iconSizeMedium,
                child: Lottie.asset(
                  AppAnimations.starsAnimation,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: AppSizes.spacingSmall),
              Expanded(
                child: Text(
                  _bannerText!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.dTextPrimary,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.spacingSmall),
              InkWell(
                onTap: _dismissBanner,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: SvgPicture.asset(
                  AppIcons.closeIcon,
                  width: AppSizes.iconSizeNormal,
                  height: AppSizes.iconSizeNormal,
                  colorFilter: ColorFilter.mode(
                    AppColors.dIconPrimary.withValues(alpha: 0.6),
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
}
