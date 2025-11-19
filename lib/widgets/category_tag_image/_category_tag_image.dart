import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class CategoryTagImage extends StatelessWidget {
  final String? imageUrl;
  final String? emoji;
  final String? colorHex;
  final double height;

  const CategoryTagImage({
    super.key,
    this.imageUrl,
    this.emoji,
    this.colorHex,
    this.height = AppSizes.welcomeBellIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return _buildCategoryImage(context, theme, imageUrl!);
    }

    if (emoji != null && emoji!.isNotEmpty) {
      return _buildTagEmoji(context, theme, emoji!, colorHex);
    }

    return const SizedBox.shrink();
  }

  Widget _buildCategoryImage(BuildContext context, ThemeData theme, String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(context, theme),
        errorWidget: (context, url, error) => _buildPlaceholder(context, theme),
      ),
    );
  }

  Widget _buildTagEmoji(BuildContext context, ThemeData theme, String emoji, String? colorHex) {
    Color? tagColor;
    if (colorHex != null && colorHex.isNotEmpty) {
      try {
        tagColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (_) {
        tagColor = null;
      }
    }

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        color: tagColor?.withValues(alpha: 0.2) ??
            theme.colorScheme.secondary.withValues(alpha: 0.4),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: theme.textTheme.displayLarge),
    );
  }

  Widget _buildPlaceholder(BuildContext context, ThemeData theme) {
    return Container(
      height: height,
      color: theme.colorScheme.secondary.withValues(alpha: 0.4),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: SizedBox(
            width: AppSizes.iconSizeMedium,
            height: AppSizes.iconSizeMedium,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
    );
  }
}

