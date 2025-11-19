import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final String? imagePath;

  const ErrorState({
    super.key,
    required this.message,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: AppSizes.welcomeBellIconSize,
                fit: BoxFit.cover,
              ),
            if (imagePath != null) const SizedBox(height: AppSizes.spacingSmall),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.labelSmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
      ),
    );
  }
}

