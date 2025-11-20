import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';

/// primary, secondary, tertiary, error
enum ButtonType { primary, secondary, tertiary, error, neutral }

enum CustomStyle { filled, outlined, borderless }

class _ButtonColorScheme {
  final Color background;
  final Color foreground;
  final Color outlinedForeground;
  final Color border;

  const _ButtonColorScheme({
    required this.background,
    required this.foreground,
    required this.outlinedForeground,
    required this.border,
  });
}

class CustomButton extends StatelessWidget {
  final String title;
  final ButtonType type;
  final CustomStyle style;
  final String? icon;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isShortText;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.type = ButtonType.primary,
    this.style = CustomStyle.filled,
    this.isLoading = false,
    this.isShortText = false,
  });

  _ButtonColorScheme _resolveColors(ButtonType type, bool isDark) {
    switch (type) {
      case ButtonType.secondary:
        return _ButtonColorScheme(
          background: isDark ? AppColors.dSecondary : AppColors.secondary,
          foreground: AppColors.textPrimary,
          outlinedForeground: isDark
              ? AppColors.dSecondary
              : AppColors.secondary,
          border: isDark ? AppColors.dSecondary : AppColors.secondary,
        );

      case ButtonType.tertiary:
        return _ButtonColorScheme(
          background: isDark ? AppColors.dTertiary : AppColors.tertiary,
          foreground: AppColors.textPrimary,
          outlinedForeground: isDark ? AppColors.dTertiary : AppColors.tertiary,
          border: isDark ? AppColors.dTertiary : AppColors.tertiary,
        );

      case ButtonType.error:
        return _ButtonColorScheme(
          background: isDark ? AppColors.dError : AppColors.error,
          foreground: isDark ? AppColors.dTextPrimary : AppColors.textPrimary,
          outlinedForeground: isDark ? AppColors.dError : AppColors.error,
          border: isDark ? AppColors.dError : AppColors.error,
        );

      case ButtonType.neutral:
        return _ButtonColorScheme(
          background: isDark ? AppColors.background : AppColors.dBackground,
          foreground: isDark ? AppColors.textPrimary : AppColors.dTextPrimary,
          outlinedForeground: isDark ? AppColors.background : AppColors.dBackground,
          border: isDark ? AppColors.background : AppColors.dBackground,
        );

      default:
        return _ButtonColorScheme(
          background: isDark ? AppColors.dPrimary : AppColors.primary,
          foreground: AppColors.textPrimary,
          outlinedForeground: isDark ? AppColors.dPrimary : AppColors.primary,
          border: isDark ? AppColors.dPrimary : AppColors.primary,
        );
    }
  }

  Color _getBackgroundColor(bool isDark) {
    if (style == CustomStyle.outlined || style == CustomStyle.borderless) {
      return Colors.transparent;
    }
    return _resolveColors(type, isDark).background;
  }

  Color _getForegroundColor(bool isDark) =>
      _resolveColors(type, isDark).foreground;

  Color _getForegroundOutlinedColor(bool isDark) =>
      _resolveColors(type, isDark).outlinedForeground;

  Color _getBorderColor(bool isDark) {
    if (style == CustomStyle.borderless) return Colors.transparent;
    return _resolveColors(type, isDark).border;
  }

  Widget? _getIconWidget(bool isDark) {
    if (isLoading) {
      return SizedBox.square(
        dimension: AppSizes.iconSizeRegular,
        child: CircularProgressIndicator(
          color: _getForegroundColor(isDark),
          strokeWidth: 2,
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
          colorFilter: ColorFilter.mode(
            _getForegroundColor(isDark),
            BlendMode.srcIn,
          ),
          height: AppSizes.iconSizeRegular,
          width: AppSizes.iconSizeRegular,
        ),
    ];
    return Row(mainAxisSize: MainAxisSize.min, children: [...widgets]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = isShortText
        ? theme.textTheme.titleSmall
        : theme.textTheme.titleLarge;
    if (style == CustomStyle.outlined || style == CustomStyle.borderless) {
      return OutlinedButton.icon(
        style: theme.outlinedButtonTheme.style?.copyWith(
          visualDensity: isShortText ? VisualDensity.standard : null,
          side: WidgetStatePropertyAll(
            BorderSide(color: _getBorderColor(isDark), width: 1.5),
          ),
        ),
        onPressed: isLoading ? null : onTap,
        icon: _getIconWidget(isDark),
        label: Center(
          child: Text(
            title,
            style: textTheme?.copyWith(
              color: _getForegroundOutlinedColor(isDark),
            ),
          ),
        ),
      );
    }
    return TextButton.icon(
      style: theme.textButtonTheme.style?.copyWith(
        visualDensity: isShortText ? VisualDensity.standard : null,
        backgroundColor: WidgetStatePropertyAll(_getBackgroundColor(isDark)),
        foregroundColor: WidgetStatePropertyAll(_getForegroundColor(isDark)),
      ),
      icon: _getIconWidget(isDark),
      onPressed: isLoading ? null : onTap,
      label: Center(
        child: Text(
          title,
          style: textTheme?.copyWith(color: _getForegroundColor(isDark)),
        ),
      ),
    );
  }
}
