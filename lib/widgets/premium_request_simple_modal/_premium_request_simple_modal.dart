import 'package:flutter/material.dart' hide AnimatedContainer;
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../widgets_exports.dart';

class PremiumRequestSimpleModal extends StatelessWidget {
  final VoidCallback onPremium;
  final VoidCallback onMaybeLater;

  const PremiumRequestSimpleModal({
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
      builder: (context) => PremiumRequestSimpleModal(
        onPremium: onPremium,
        onMaybeLater: onMaybeLater,
      ),
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
        horizontal: AppSizes.paddingSmall,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  splashColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.closeIcon,
                    width: AppSizes.iconSizeMedium,
                    colorFilter: ColorFilter.mode(
                      theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingMedium),
           
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
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            Text(
              lang.premiumRequestSubtitle,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            CustomButton(
              title: lang.premiumStartNowButton,
              type: ButtonType.neutral,
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
}

