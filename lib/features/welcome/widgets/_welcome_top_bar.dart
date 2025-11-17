import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';
import '../../../widgets/widgets_exports.dart';

class WelcomeTopBar extends StatelessWidget {
  final int index;
  final double progress;
  final VoidCallback onBack;

  const WelcomeTopBar({
    super.key,
    required this.index,
    required this.progress,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isPaywallOrRating = index >= 9;

    return SizedBox(
      height: AppSizes.iconSizeXLarge,
      child: AnimatedOpacity(
        opacity: index > 0 ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
          child: Row(
            children: [
              if (!isPaywallOrRating) ...[
                InkWell(
                  onTap: onBack,
                  splashColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.arrowLeftIcon,
                    width: AppSizes.iconSizeXLarge,
                    colorFilter: ColorFilter.mode(
                      theme.primaryIconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.spacingSmall),
                Expanded(child: GradientProgressBar(value: progress)),
              ],
              if (isPaywallOrRating) ...[
                Expanded(child: Container()),
                InkWell(
                  // TODO: FIX CLOSE BTN LOGIC
                  onTap: onBack,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.closeIcon,
                    width: AppSizes.iconSizeLarge,
                    colorFilter: ColorFilter.mode(
                      isDark ? AppColors.dIconTertiary : AppColors.iconTertiary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
