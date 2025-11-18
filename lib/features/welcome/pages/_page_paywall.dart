import 'package:flutter/material.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/card_container/_card_container.dart';
import '../widgets/_section_container.dart';

class PagePaywall extends StatelessWidget {
  const PagePaywall({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    return SectionContainer(
      title: lang.paywallTitle,
      subtitle: lang.paywallSubtitle,
      spacingAfterSubtitle: AppSizes.spacingXLarge,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.guidedFaithPlans,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  lang.unlimitedMoodTrack,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  lang.advanceProgressTracker,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  lang.adfreeExperience,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              AppIcons.happyPetImage,
              height: AppSizes.welcomeBellIconSize,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}

