import 'package:flutter/material.dart' hide AnimatedContainer;
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../widgets_exports.dart';

class PremiumRequestModal extends StatelessWidget {
  final VoidCallback onPremium;
  final VoidCallback onMaybeLater;

  const PremiumRequestModal({
    super.key,
    required this.onPremium,
    required this.onMaybeLater,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onPremium,
    required VoidCallback onMaybeLater,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          PremiumRequestModal(onPremium: onPremium, onMaybeLater: onMaybeLater),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingLarge,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              mode: AnimationMode.floating,
              duration: const Duration(seconds: 2),
              floatRange: 6,
              child: Image.asset(
                AppIcons.happyPetImage,
                height: AppSizes.premiumIconSize,
              ),
            ),
            Text(
              lang.premiumRequestTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Text(
              lang.premiumRequestSubtitle,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBenefit(
                      context: context,
                      theme: theme,
                      lang: lang,
                      icon: AppIcons.openBookFilledIcon,
                      title: lang.premiumBenefit1Title,
                      subtitle: lang.premiumBenefit1Subtitle,
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    _buildBenefit(
                      context: context,
                      theme: theme,
                      lang: lang,
                      icon: AppIcons.lineChartIcon,
                      title: lang.premiumBenefit2Title,
                      subtitle: lang.premiumBenefit2Subtitle,
                    ),
                    const SizedBox(height: AppSizes.spacingMedium),
                    _buildBenefit(
                      context: context,
                      theme: theme,
                      lang: lang,
                      icon: AppIcons.noAdsIcon,
                      title: lang.premiumBenefit3Title,
                      subtitle: lang.premiumBenefit3Subtitle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            CustomButton(
              title: lang.premiumStartNowButton,
              type: ButtonType.primary,
              onTap: () {
                Navigator.of(context).pop();
                onPremium();
              },
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            CustomButton(
              title: lang.maybeLater,
              type: ButtonType.neutral,
              style: CustomStyle.borderless,
              isShortText: true,
              onTap: () {
                Navigator.of(context).pop();
                onMaybeLater();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required BuildContext context,
    required ThemeData theme,
    required S lang,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.paddingSmall),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            icon,
            width: AppSizes.iconSizeLarge,
            height: AppSizes.iconSizeLarge,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spacingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSizes.spacingXXSmall),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
