import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_exports.dart';
import '../../routes/app_routes_names.dart';

class DevotionalTagChip extends StatelessWidget {
  final Tag tag;
  final bool isClickable;
  final VoidCallback? onTap;

  const DevotionalTagChip({
    super.key,
    required this.tag,
    this.isClickable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? tagColor;
    if (tag.color != null && tag.color!.isNotEmpty) {
      try {
        tagColor = Color(int.parse(tag.color!.replaceFirst('#', '0xFF')));
      } catch (_) {
        tagColor = null;
      }
    }

    Widget chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.paddingXXSmall,
      ),
      decoration: BoxDecoration(
        color: tagColor?.withValues(alpha: 0.05) ??
            theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: tagColor?.withValues(alpha: 0.3) ??
              theme.colorScheme.primary.withValues(alpha: 0.3),
          width: AppSizes.borderWithSmall,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag.icon != null) ...[
            Text(tag.icon!, style: theme.textTheme.bodyMedium),
            const SizedBox(width: AppSizes.spacingXSmall),
          ],
          Text(
            tag.name ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: tagColor ?? theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (!isClickable) {
      return chip;
    }

    return GestureDetector(
      onTap: onTap ??
          () {
            if (context.mounted) {
              // Note: This widget doesn't have access to WidgetRef
              // If you need ads here, you'll need to pass ref or use a different approach
              context.push(Routes.categoryDevotionals, extra: {'tag': tag});
            }
          },
      child: chip,
    );
  }
}

