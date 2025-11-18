import 'package:faithmood_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../../../core/core_exports.dart';
import '../../../widgets/widgets_exports.dart';

class WelcomeBottomButtons extends StatelessWidget {
  final int index;
  final bool isLoading;
  final VoidCallback onNext;
  final VoidCallback? onPrimaryTapOverride;
  final VoidCallback? onSecondaryTap;

  const WelcomeBottomButtons({
    super.key,
    required this.index,
    required this.isLoading,
    required this.onNext,
    this.onPrimaryTapOverride,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
      child: Column(
        children: [
          if (index == 8) ...[
            Text(
              lang.psaml231Verse,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: AppSizes.spacingSmall),
            Text(
              lang.psalm231,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],

          if (index == 9) ...[
            Text(
              lang.noPaymentRequiredNow,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: theme.textTheme.titleSmall?.fontWeight,
              ),
            ),
            SizedBox(height: AppSizes.spacingSmall),
          ],

          if (index != 8)
            CustomButton(
              title: _label(index, lang),
              isLoading: isLoading,
              type: ButtonType.primary,
              style: CustomStyle.filled,
              onTap: onPrimaryTapOverride ?? onNext,
            ),

          if (index == 9) ...[
            SizedBox(height: AppSizes.spacingSmall),
            Text(
              lang.just449PerMonthCancelAnytime.replaceAll('###', '\$4.49'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: theme.textTheme.titleSmall?.fontWeight,
                color: theme.textTheme.labelSmall?.color,
              ),
            ),
          ],

          if (index == 7 || index == 11) ...[
            SizedBox(height: AppSizes.spacingSmall),
            CustomButton(
              title: lang.maybeLater,
              type: ButtonType.primary,
              style: CustomStyle.borderless,
              isShortText: true,
              onTap: onSecondaryTap ?? onNext,
            ),
          ],
        ],
      ),
    );
  }

  String _label(int i, S lang) {
    if (i == 0) return lang.getStarted;
    if (i == 7) return lang.allowNotifications;
    if (i == 9) return lang.startFreeTrial;
    if (i == 11) return lang.leaveRating;
    return lang.continueText;
  }
}
