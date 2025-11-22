import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../widgets_exports.dart';

class PremiumPromotionCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonTitle;
  final String? imagePath;
  final VoidCallback? onButtonTap;

  const PremiumPromotionCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonTitle,
    this.imagePath,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  width: AppSizes.welcomeBellIconSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingSmall),
                      Text(
                        description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (imagePath != null)
                  Positioned(
                    right: -30,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        imagePath!,
                        width: AppSizes.dialogIconSize,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacingMedium),
          CustomButton(
            title: buttonTitle,
            type: ButtonType.neutral,
            isShortText: true,
            onTap: onButtonTap ?? () {},
          ),
        ],
      ),
    );
  }
}

