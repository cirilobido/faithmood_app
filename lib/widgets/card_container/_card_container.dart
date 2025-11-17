import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        border: Border.all(
          color: theme.colorScheme.outline,
          width: AppSizes.borderWithSmall,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: child,
    );
  }
}
