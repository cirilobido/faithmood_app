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

