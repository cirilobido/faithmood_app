import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardPrimary,
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderWithSmall,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: child,
    );
  }
}
