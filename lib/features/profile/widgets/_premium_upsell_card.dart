import 'package:flutter/material.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';

class PremiumUpsellCard extends StatelessWidget {
  const PremiumUpsellCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Column(
      children: [
        const SizedBox(height: AppSizes.spacingMedium),
        Image.asset(
          AppIcons.greenChartImage,
          height: AppSizes.dialogIconSize,
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            // TODO: Navigate to subscription screen
            // context.push(Routes.subscription);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              lang.unlockPremiumToGetAccessToAllStatsAndFeatures,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spacingLarge),
      ],
    );
  }
}

