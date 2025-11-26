import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';

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
    final tagIcon = isPremium ? '🔒' : devotional.iconEmoji ?? fallbackIcon;
    final tags = devotional.tags ?? [];
    final hasTags = tags.isNotEmpty;

    return InkWell(
      splashColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
              border: Border.all(
                color: theme.colorScheme.secondary,
                width: AppSizes.borderWithSmall,
              ),
            ),
            child: Row(
              children: [
                _buildIcon(context, theme, tagIcon, isPremium),
                const SizedBox(width: AppSizes.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isPremium) SizedBox(height: AppSizes.spacingXSmall),
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
                      if (hasTags) ...[
                        const SizedBox(height: AppSizes.spacingXSmall),
                        SizedBox(
                          height: AppSizes.tagChipCardHeight,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: tags.map((tag) {
                              final tagName = tag.name ?? '';
                              if (tagName.isEmpty)
                                return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSizes.spacingXSmall,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    AppSizes.paddingXSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusFull,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.spacingXSmall,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${tag.icon ?? ''}$tagName',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: theme
                                                    .textTheme
                                                    .labelSmall
                                                    ?.color,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Premium badge
          if (isPremium) _buildPremiumBadge(context, theme),
        ],
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context,
    ThemeData theme,
    String? icon,
    bool isPremium,
  ) {
    // Prioritize coverImage, then fallback to iconEmoji
    if (devotional.coverImage != null && devotional.coverImage!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: devotional.coverImage!,
          width: AppSizes.iconSizeXXLarge,
          height: AppSizes.iconSizeXXLarge,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              _buildIconPlaceholder(context, theme, icon, isPremium),
          errorWidget: (context, url, error) =>
              _buildIconPlaceholder(context, theme, icon, isPremium),
        ),
      );
    }

    // Fallback to iconEmoji if coverImage is not available
    final displayIcon = icon ?? devotional.iconEmoji;
    if (displayIcon != null && displayIcon.isNotEmpty) {
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
          displayIcon,
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

  Widget _buildIconPlaceholder(
    BuildContext context,
    ThemeData theme,
    String? icon,
    bool isPremium,
  ) {
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

  Widget _buildPremiumBadge(BuildContext context, ThemeData theme) {
    final lang = S.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSmall,
          vertical: AppSizes.paddingXSmall,
        ),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.secondary : AppColors.dBackground,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSizes.radiusFull),
            bottomLeft: Radius.circular(AppSizes.radiusMedium),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.starIcon,
              width: AppSizes.iconSizeSmall,
              height: AppSizes.iconSizeSmall,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.tertiary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSizes.spacingXXSmall),
            Text(
              lang.premium,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.textPrimary : AppColors.dTextPrimary,
                fontWeight: theme.textTheme.titleSmall?.fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
