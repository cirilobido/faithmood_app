import 'package:flutter/material.dart' hide AnimatedContainer;
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../widgets_exports.dart';

class ReviewRequestModal extends StatelessWidget {
  final VoidCallback onReview;
  final VoidCallback onNeverAsk;

  const ReviewRequestModal({
    super.key,
    required this.onReview,
    required this.onNeverAsk,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onReview,
    required VoidCallback onNeverAsk,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ReviewRequestModal(onReview: onReview, onNeverAsk: onNeverAsk),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppIcons.oatLeftIcon,
                  width: AppSizes.iconSizeLarge,
                  colorFilter: ColorFilter.mode(
                    theme.iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        mode: AnimationMode.floating,
                        duration: const Duration(seconds: 2),
                        floatRange: 6,
                        child: SvgPicture.asset(
                          AppIcons.starsRatingIcon,
                          height: AppSizes.iconSizeMedium,
                        ),
                      ),
                      SizedBox(height: AppSizes.spacingSmall),
                      Text(
                        lang.reviewRequestTitle,
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.oatRightIcon,
                  width: AppSizes.iconSizeLarge,
                  colorFilter: ColorFilter.mode(
                    theme.iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            Text(
              lang.reviewRequestContent,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            CustomButton(
              title: lang.reviewButton,
              type: ButtonType.neutral,
              onTap: () {
                Navigator.of(context).pop();
                onReview();
              },
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            CustomButton(
              title: lang.neverAskButton,
              type: ButtonType.neutral,
              style: CustomStyle.borderless,
              isShortText: true,
              onTap: () {
                Navigator.of(context).pop();
                onNeverAsk();
              },
            ),
          ],
        ),
      ),
    );
  }
}
