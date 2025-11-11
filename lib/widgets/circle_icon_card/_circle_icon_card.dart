import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/core_exports.dart';

class CircleIconCard extends StatelessWidget {
  final String iconPath;
  final String? label;
  final Color? iconColor;
  final double? iconSize;
  final double? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;
  final double spacing;

  const CircleIconCard({
    super.key,
    required this.iconPath,
    this.label,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.labelStyle,
    this.onTap,
    this.spacing = AppSizes.spacingSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                width: borderWidth ?? AppSizes.borderWithSmall,
                color: borderColor ?? AppColors.border,
              ),
            ),
            padding: EdgeInsets.all(padding ?? AppSizes.paddingSmall),
            child: SvgPicture.asset(
              iconPath,
              width: iconSize ?? AppSizes.iconSizeMedium,
              height: iconSize ?? AppSizes.iconSizeMedium,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(
                      iconColor ?? AppColors.icon,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
          ),
        ),
        if (label != null) ...[
          SizedBox(height: spacing),
          Text(
            label!,
            style:
                labelStyle ??
                Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ],
    );
  }
}
