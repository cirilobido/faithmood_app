import 'package:flutter/material.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../widgets/_section_container.dart';

class PageJoinOther extends StatelessWidget {
  const PageJoinOther({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    return SectionContainer(
      title: lang.joinOthersTitle,
      subtitle: null,
      spacingAfterTitle: AppSizes.spacingSmall,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  AppIcons.greenChartImage,
                  fit: BoxFit.fitWidth,
                ),
              ),

              Positioned(
                top: AppSizes.spacingXLarge,
                left: 0,
                child: Text(
                  lang.growInFaith,
                  style: theme.textTheme.titleSmall,
                ),
              ),

              Positioned.fill(
                bottom: -240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(
                      color: theme.colorScheme.outline,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lang.days3, style: theme.textTheme.labelLarge),
                        Text(lang.days15, style: theme.textTheme.labelLarge),
                        Text(lang.days30, style: theme.textTheme.labelLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSizes.spacingLarge),

          Text(
            lang.joinOthersSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

