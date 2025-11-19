import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';

class DevotionalItemCard extends StatelessWidget {
  final Devotional devotional;
  final String? fallbackIcon;
  final VoidCallback? onTap;

  const DevotionalItemCard({
    super.key,
    required this.devotional,
    this.fallbackIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremium = devotional.isPremium ?? false;
    final tagIcon = isPremium
        ? '🔒'
        : devotional.iconEmoji ?? fallbackIcon;

    return InkWell(
      splashColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: isPremium
              ? theme.colorScheme.tertiary.withValues(alpha: 0.4)
              : theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        ),
        child: Row(
          children: [
            _buildIcon(context, theme, tagIcon, isPremium),
            const SizedBox(width: AppSizes.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    devotional.title ?? '',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    devotional.content ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppIcons.arrowRightIcon,
              width: AppSizes.iconSizeMedium,
              colorFilter: ColorFilter.mode(
                theme.iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, ThemeData theme, String? icon, bool isPremium) {
    if (devotional.coverImage != null && devotional.coverImage!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: devotional.coverImage!,
          width: AppSizes.iconSizeXXLarge,
          height: AppSizes.iconSizeXXLarge,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildIconPlaceholder(context, theme, icon, isPremium),
          errorWidget: (context, url, error) => _buildIconPlaceholder(context, theme, icon, isPremium),
        ),
      );
    }

    if (icon != null && icon.isNotEmpty) {
      return Container(
        width: AppSizes.iconSizeXXLarge,
        height: AppSizes.iconSizeXXLarge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPremium
              ? theme.colorScheme.surface
              : theme.colorScheme.secondary.withValues(alpha: 0.2),
        ),
        alignment: Alignment.center,
        child: Text(
          icon,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
      );
    }

    return Container(
      width: AppSizes.iconSizeXXLarge,
      height: AppSizes.iconSizeXXLarge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildIconPlaceholder(BuildContext context, ThemeData theme, String? icon, bool isPremium) {
    return Container(
      width: AppSizes.iconSizeXXLarge,
      height: AppSizes.iconSizeXXLarge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPremium
            ? theme.colorScheme.surface
            : theme.colorScheme.primary.withValues(alpha: 0.2),
      ),
      alignment: Alignment.center,
      child: icon != null && icon.isNotEmpty
          ? Text(
              icon,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            )
          : null,
    );
  }
}

