import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../widgets_exports.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final String icon;
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          border: Border.all(
            color: color.withValues(alpha: 0.6),
            width: AppSizes.borderWithSmall,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleIconCard(
              iconPath: icon,
              iconColor: color,
              backgroundColor: color.withValues(alpha: 0.15),
              borderColor: color.withValues(alpha: 0.15),
              borderWidth: 0,
            ),
            const SizedBox(width: AppSizes.spacingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

