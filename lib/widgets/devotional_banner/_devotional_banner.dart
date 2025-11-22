import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';

class DevotionalBanner extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String? coverImage;
  final String title;
  final String content;
  final String? categoryTitle;
  final bool isPremium;
  final VoidCallback? onTap;
  final double height;

  const DevotionalBanner({
    super.key,
    required this.isLoading,
    required this.hasError,
    this.coverImage,
    required this.title,
    required this.content,
    this.categoryTitle,
    this.isPremium = false,
    this.onTap,
    this.height = 148,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: isLoading
          ? _buildLoadingState(theme)
          : hasError
          ? _buildErrorState(context, theme)
          : _buildContent(context, theme),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.tertiary.withValues(alpha: 0.4),
            theme.colorScheme.secondary.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          child: SizedBox(
            width: AppSizes.iconSizeMedium,
            height: AppSizes.iconSizeMedium,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.tertiary.withValues(alpha: 0.4),
            theme.colorScheme.secondary.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.primary),
            const SizedBox(height: AppSizes.spacingXSmall),
            Text(
              S.of(context).unableToLoadDevotional,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.labelSmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
          gradient: coverImage != null
              ? null
              : LinearGradient(
                  colors: [
                    theme.colorScheme.tertiary.withValues(alpha: 0.4),
                    theme.colorScheme.secondary.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Stack(
          children: [
            if (coverImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
                child: Image.network(
                  coverImage!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.tertiary.withValues(alpha: 0.4),
                            theme.colorScheme.secondary.withValues(alpha: 0.4),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (categoryTitle != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmall,
                            vertical: AppSizes.paddingXXSmall,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSmall,
                            ),
                          ),
                          child: Text(
                            categoryTitle!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (isPremium)
                        Container(
                          padding: const EdgeInsets.all(
                            AppSizes.paddingXXSmall,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withValues(
                              alpha: 0.8,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            size: 16,
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title.isNotEmpty)
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: coverImage != null
                                ? Colors.white
                                : theme.textTheme.titleMedium?.color,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (content.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.spacingXSmall),
                        Text(
                          content,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: coverImage != null
                                ? Colors.white.withOpacity(0.9)
                                : theme.textTheme.bodySmall?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
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
