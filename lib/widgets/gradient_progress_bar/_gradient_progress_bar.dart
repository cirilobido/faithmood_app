import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class GradientProgressBar extends StatelessWidget {
  final double value;

  const GradientProgressBar({super.key, required this.value});

  LinearGradient _getGradientColors() {
    return AppColors.progressGradient;
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradientColors();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Stack(
        children: [
          Container(color: AppColors.background, height: AppSizes.spacingSmall),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              height: AppSizes.spacingSmall,
              decoration: BoxDecoration(gradient: gradient),
            ),
          ),
        ],
      ),
    );
  }
}
