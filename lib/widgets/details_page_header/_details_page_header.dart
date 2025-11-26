import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';

class DetailsPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final DetailsPageHeaderAction? action;

  const DetailsPageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingMedium,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack ?? () => Navigator.of(context).pop(),
            splashColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: SvgPicture.asset(
              AppIcons.arrowLeftIcon,
              width: AppSizes.iconSizeMedium,
              colorFilter: ColorFilter.mode(
                theme.primaryIconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          if (action != null) action!.build(context, theme) else SizedBox(width: AppSizes.iconSizeMedium),
        ],
      ),
    );
  }
}

abstract class DetailsPageHeaderAction {
  Widget build(BuildContext context, ThemeData theme);
}

class MenuHeaderAction extends DetailsPageHeaderAction {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  MenuHeaderAction({
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, ThemeData theme) {
    final lang = S.of(context);
    return SizedBox(
      width: AppSizes.iconSizeNormal,
      height: AppSizes.iconSizeNormal,
      child: Align(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          iconSize: AppSizes.iconSizeNormal,
          splashRadius: AppSizes.iconSizeNormal / 2,
          icon: SvgPicture.asset(
            AppIcons.moreVerticalIcon,
            width: AppSizes.iconSizeNormal,
            height: AppSizes.iconSizeNormal,
            colorFilter: ColorFilter.mode(
              theme.primaryIconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          onSelected: (value) {
            if (value == 'edit' && onEdit != null) {
              onEdit!();
            } else if (value == 'delete' && onDelete != null) {
              onDelete!();
            }
          },
          itemBuilder: (BuildContext context) => [
            if (onEdit != null)
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: AppSizes.iconSizeNormal,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.edit,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (onDelete != null)
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: AppSizes.iconSizeNormal,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.delete,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
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

class FavoriteHeaderAction extends DetailsPageHeaderAction {
  final bool isFavorite;
  final VoidCallback onToggle;

  FavoriteHeaderAction({
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: onToggle,
      splashColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      child: SvgPicture.asset(
        isFavorite ? AppIcons.bookmarkFilledIcon : AppIcons.bookmarkIcon,
        width: AppSizes.iconSizeMedium,
        colorFilter: ColorFilter.mode(
          isFavorite
              ? theme.colorScheme.primary
              : theme.primaryIconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class CompositeHeaderAction extends DetailsPageHeaderAction {
  final List<Widget> actions;

  CompositeHeaderAction({
    required this.actions,
  });

  @override
  Widget build(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions
          .map((action) => Padding(
                padding: const EdgeInsets.only(left: AppSizes.spacingMedium),
                child: action,
              ))
          .toList(),
    );
  }
}

class TtsHeaderAction extends DetailsPageHeaderAction {
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onTap;

  TtsHeaderAction({
    required this.isPlaying,
    required this.isPaused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, ThemeData theme) {
    IconData icon;
    Color? iconColor;

    if (isPlaying) {
      icon = Icons.pause;
      iconColor = theme.colorScheme.primary;
    } else if (isPaused) {
      icon = Icons.play_arrow;
      iconColor = theme.colorScheme.primary;
    } else {
      icon = Icons.volume_up;
      iconColor = theme.primaryIconTheme.color;
    }

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      child: Icon(
        icon,
        size: AppSizes.iconSizeMedium,
        color: iconColor,
      ),
    );
  }
}

class DevotionalOptionsHeaderAction extends DetailsPageHeaderAction {
  final bool isFavorite;
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTtsTap;
  final VoidCallback? onShare;

  DevotionalOptionsHeaderAction({
    required this.isFavorite,
    required this.isPlaying,
    required this.isPaused,
    required this.onToggleFavorite,
    required this.onTtsTap,
    this.onShare,
  });

  @override
  Widget build(BuildContext context, ThemeData theme) {
    final lang = S.of(context);
    return SizedBox(
      width: AppSizes.iconSizeNormal,
      height: AppSizes.iconSizeNormal,
      child: Align(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          iconSize: AppSizes.iconSizeMedium,
          splashRadius: AppSizes.iconSizeMedium / 2,
          icon: SvgPicture.asset(
            AppIcons.moreVerticalIcon,
            width: AppSizes.iconSizeMedium,
            height: AppSizes.iconSizeMedium,
            colorFilter: ColorFilter.mode(
              theme.primaryIconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          onSelected: (value) {
            if (value == 'tts') {
              onTtsTap();
            } else if (value == 'favorite') {
              onToggleFavorite();
            } else if (value == 'share' && onShare != null) {
              onShare!();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'tts',
              child: Row(
                children: [
                  Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: AppSizes.iconSizeNormal,
                    color: theme.iconTheme.color,
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Text(
                    isPlaying ? lang.pause : lang.play,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // PopupMenuItem<String>(
            //   value: 'favorite',
            //   child: Row(
            //     children: [
            //       Icon(
            //         isFavorite ? Icons.bookmark : Icons.bookmark_border,
            //         size: AppSizes.iconSizeNormal,
            //         color: isFavorite
            //             ? theme.colorScheme.primary
            //             : theme.iconTheme.color,
            //       ),
            //       const SizedBox(width: AppSizes.spacingSmall),
            //       Text(
            //         isFavorite ? lang.removeFromFavorites : lang.addToFavorites,
            //         style: theme.textTheme.bodyMedium?.copyWith(
            //           fontWeight: FontWeight.w600,
            //           color: isFavorite ? theme.colorScheme.primary : null,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            if (onShare != null)
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      size: AppSizes.iconSizeNormal,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.share,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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

class MoodEntryOptionsHeaderAction extends DetailsPageHeaderAction {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onTtsTap;
  final VoidCallback? onShare;

  MoodEntryOptionsHeaderAction({
    this.onEdit,
    this.onDelete,
    required this.isPlaying,
    required this.isPaused,
    required this.onTtsTap,
    this.onShare,
  });

  @override
  Widget build(BuildContext context, ThemeData theme) {
    final lang = S.of(context);
    return SizedBox(
      width: AppSizes.iconSizeNormal,
      height: AppSizes.iconSizeNormal,
      child: Align(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          iconSize: AppSizes.iconSizeMedium,
          splashRadius: AppSizes.iconSizeMedium / 2,
          icon: SvgPicture.asset(
            AppIcons.moreVerticalIcon,
            width: AppSizes.iconSizeMedium,
            height: AppSizes.iconSizeMedium,
            colorFilter: ColorFilter.mode(
              theme.primaryIconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          onSelected: (value) {
            if (value == 'tts') {
              onTtsTap();
            } else if (value == 'edit' && onEdit != null) {
              onEdit!();
            } else if (value == 'delete' && onDelete != null) {
              onDelete!();
            } else if (value == 'share' && onShare != null) {
              onShare!();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'tts',
              child: Row(
                children: [
                  Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: AppSizes.iconSizeNormal,
                    color: theme.iconTheme.color,
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Text(
                    isPlaying ? lang.pause : lang.play,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onShare != null)
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      size: AppSizes.iconSizeNormal,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.share,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (onEdit != null)
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: AppSizes.iconSizeNormal,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.edit,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (onDelete != null)
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: AppSizes.iconSizeNormal,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.delete,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error,
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

class DevotionalLogOptionsHeaderAction extends DetailsPageHeaderAction {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onTtsTap;

  DevotionalLogOptionsHeaderAction({
    this.onEdit,
    this.onDelete,
    required this.isPlaying,
    required this.isPaused,
    required this.onTtsTap,
  });

  @override
  Widget build(BuildContext context, ThemeData theme) {
    final lang = S.of(context);
    return SizedBox(
      width: AppSizes.iconSizeNormal,
      height: AppSizes.iconSizeNormal,
      child: Align(
        alignment: Alignment.centerRight,
        child: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          iconSize: AppSizes.iconSizeMedium,
          splashRadius: AppSizes.iconSizeMedium / 2,
          icon: SvgPicture.asset(
            AppIcons.moreVerticalIcon,
            width: AppSizes.iconSizeMedium,
            height: AppSizes.iconSizeMedium,
            colorFilter: ColorFilter.mode(
              theme.primaryIconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          onSelected: (value) {
            if (value == 'tts') {
              onTtsTap();
            } else if (value == 'edit' && onEdit != null) {
              onEdit!();
            } else if (value == 'delete' && onDelete != null) {
              onDelete!();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'tts',
              child: Row(
                children: [
                  Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: AppSizes.iconSizeNormal,
                    color: theme.iconTheme.color,
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Text(
                    isPlaying ? lang.pause : lang.play,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: AppSizes.iconSizeNormal,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.edit,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (onDelete != null)
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: AppSizes.iconSizeNormal,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      lang.delete,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error,
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

