import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';

/// primary, secondary, tertiary, error
enum ButtonType { primary, secondary, tertiary, error }

enum CustomStyle { filled, outlined, borderless }

class CustomButton extends StatelessWidget {
  final String title;
  final ButtonType type;
  final CustomStyle style;
  final String? icon;
  final VoidCallback onTap;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.type = ButtonType.primary,
    this.style = CustomStyle.filled,
    this.isLoading = false,
  });

  Color _getBackgroundColor() {
    if (style == CustomStyle.outlined || style == CustomStyle.borderless) {
      return Colors.transparent;
    }
    if (type == ButtonType.secondary) {
      return AppColors.secondary;
    }
    if (type == ButtonType.tertiary) {
      return Colors.transparent;
    }
    if (type == ButtonType.error) {
      return AppColors.error;
    }
    return AppColors.primary;
  }

  Color _getForegroundColor() {
    if (type == ButtonType.secondary) {
      return AppColors.dTextPrimary;
    }
    if (type == ButtonType.tertiary) {
      return AppColors.primary;
    }
    if (type == ButtonType.error) {
      return AppColors.textPrimary;
    }
    return AppColors.textPrimary;
  }

  Color _getForegroundOutlinedColor() {
    if (type == ButtonType.secondary) {
      return AppColors.secondary;
    }
    if (type == ButtonType.tertiary) {
      return AppColors.textPrimary;
    }
    if (type == ButtonType.error) {
      return AppColors.error;
    }
    return AppColors.primary;
  }

  Color _getBorderColor() {
    if (style == CustomStyle.borderless) {
      return Colors.transparent;
    }
    if (type == ButtonType.secondary) {
      return AppColors.secondary;
    }
    if (type == ButtonType.tertiary) {
      return AppColors.textPrimary;
    }
    if (type == ButtonType.error) {
      return AppColors.error;
    }
    return AppColors.primary;
  }

  Widget? _getIconWidget() {
    if (isLoading) {
      return SizedBox.square(
        dimension: AppSizes.iconSizeRegular,
        child: CircularProgressIndicator(
          color: _getForegroundColor(),
          strokeWidth: 1,
        ),
      );
    }
    if (icon == null) {
      return null;
    }
    final widgets = [
      if (icon != null && !isLoading)
        SvgPicture.asset(
          icon!,
          colorFilter: ColorFilter.mode(_getForegroundColor(), BlendMode.srcIn),
          height: AppSizes.iconSizeRegular,
          width: AppSizes.iconSizeRegular,
        ),
    ];
    return Row(mainAxisSize: MainAxisSize.min, children: [...widgets]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (style == CustomStyle.outlined || style == CustomStyle.borderless) {
      return OutlinedButton.icon(
        style: theme.outlinedButtonTheme.style?.copyWith(
          side: WidgetStatePropertyAll(
            BorderSide(color: _getBorderColor(), width: 1.5),
          ),
        ),
        onPressed: isLoading ? null : onTap,
        icon: _getIconWidget(),
        label: Center(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: _getForegroundOutlinedColor(),
            ),
          ),
        ),
      );
    }
    return TextButton.icon(
      style: theme.textButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(_getBackgroundColor()),
        foregroundColor: WidgetStatePropertyAll(_getForegroundColor()),
      ),
      icon: _getIconWidget(),
      onPressed: isLoading ? null : onTap,
      label: Center(
        child: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: _getForegroundColor(),
          ),
        ),
      ),
    );
  }
}
