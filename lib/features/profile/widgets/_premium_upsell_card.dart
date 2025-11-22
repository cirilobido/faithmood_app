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
                colors: [
                  theme.colorScheme.secondary,
                  theme.colorScheme.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Text(
              lang.unlockPremiumToGetAccessToAllStatsAndFeatures,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }
}
