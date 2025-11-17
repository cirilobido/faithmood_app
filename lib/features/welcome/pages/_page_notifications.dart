import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../widgets/_section_container.dart';

class PageNotifications extends StatelessWidget {
  const PageNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SectionContainer(
      key: key,
      title: lang.askNotificationTitle,
      subtitle: lang.askNotificationSubtitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  AppIcons.greenFigureIcon,
                  height: AppSizes.welcomeFigureIconSize,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.secondary.withValues(
                      alpha: isDark ? 0.4 : 1,
                    ),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  AppIcons.bellBlueIcon,
                  height: AppSizes.welcomeBellIconSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
