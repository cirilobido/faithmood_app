import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../widgets/_section_container.dart';

class PageRating extends StatelessWidget {
  const PageRating({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    return SectionContainer(
      title: lang.ratingContentTitle,
      subtitle: lang.ratingContentSubtitle,
      spacingAfterSubtitle: AppSizes.spacingXLarge,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.oatLeftIcon,
                width: AppSizes.iconSizeXLarge,
                colorFilter: ColorFilter.mode(
                  theme.iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AppIcons.starsRatingIcon,
                      height: AppSizes.iconSizeLarge,
                    ),
                    SizedBox(height: AppSizes.spacingSmall),

                    Text(
                      lang.ratingContentDesc,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                AppIcons.oatRightIcon,
                width: AppSizes.iconSizeXLarge,
                colorFilter: ColorFilter.mode(
                  theme.iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingLarge),
          _testimonialCircles(),
          SizedBox(height: AppSizes.spacingXLarge),
          CardContainer(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleImageCard(
                      asset: AppIcons.person4Image,
                      size: AppSizes.iconSizeMedium,
                      color: theme.colorScheme.secondary,
                    ),
                    SizedBox(width: AppSizes.spacingSmall),
                    Expanded(
                      child: Text(
                        "Eva C.",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.star5Icon,
                      height: AppSizes.iconSizeSmall,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingSmall),
                Text(
                  lang.ratingContentP4Rating,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _testimonialCircles() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleImageCard(asset: AppIcons.person4Image, offsetX: 15),
            CircleImageCard(asset: AppIcons.person1Image, offsetX: 0),
            CircleImageCard(asset: AppIcons.person2Image, offsetX: -15),
            CircleImageCard(asset: AppIcons.person3Image, offsetX: -30),
          ],
        ),
      ],
    );
  }
}

