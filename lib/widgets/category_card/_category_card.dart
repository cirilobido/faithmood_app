import 'dart:ui';

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../widgets_exports.dart';

class CategoryCard extends StatelessWidget {
  final String? title;
  final String? description;
  final String? coverImage;
  final String? iconEmoji;
  final bool isPremium;
  final VoidCallback? onTap;
  final String? ctaText;

  const CategoryCard({
    super.key,
    this.title,
    this.description,
    this.coverImage,
    this.iconEmoji,
    this.isPremium = false,
    this.onTap,
    this.ctaText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final buttonText = ctaText ?? (isPremium ? lang.unlockNow : lang.explore);

    return InkWell(
      onTap: isPremium ? null : onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        child: Stack(
          children: [
            if (coverImage != null && coverImage!.isNotEmpty)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: coverImage!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null && title!.isNotEmpty)
                          Text(
                            title!,
                            style: theme.textTheme.titleLarge,
                          ),
                        if (description != null && description!.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.spacingXSmall),
                          Text(
                            description!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.textTheme.labelSmall?.color,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: AppSizes.spacingMedium),
                        CustomButton(
                          title: buttonText,
                          type: ButtonType.neutral,
                          isShortText: true,
                          icon: isPremium ? AppIcons.lockIcon : null,
                          onTap: () {
                            if (!isPremium && onTap != null) {
                              onTap!();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if (iconEmoji != null && iconEmoji!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSizes.spacingSmall,
                      ),
                      child: Text(
                        iconEmoji!,
                        style: theme.textTheme.displaySmall,
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

