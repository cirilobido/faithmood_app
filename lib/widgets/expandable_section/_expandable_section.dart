import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final Widget content;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.content,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: AppSizes.borderWithSmall,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: AppSizes.borderWithSmall,
              color: theme.colorScheme.outlineVariant,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: content,
            ),
          ],
        ],
      ),
    );
  }
}

