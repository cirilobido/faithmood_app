import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final CrossAxisAlignment alignment;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: titleStyle ?? theme.textTheme.titleMedium,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSizes.spacingXSmall),
          Text(
            subtitle!,
            style: subtitleStyle ??
                theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                ),
          ),
        ],
      ],
    );
  }
}

