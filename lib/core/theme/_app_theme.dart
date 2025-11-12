// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:faithmood_app/core/core_exports.dart';

// 🌎 Project imports:

abstract class AppTheme {
  static const _fontFamily = 'Quicksand';

  static ThemeData lightTheme() {
    final baseTheme = ThemeData.light();
    final textTheme = _getTextTheme(baseTheme.textTheme, false);
    return baseTheme.copyWith(
      textTheme: textTheme,
      elevatedButtonTheme: _getElevatedButtonTheme(textTheme, false),
      textButtonTheme: _getTextButtonTheme(false),
      outlinedButtonTheme: _getOutlineButtonTheme(false),
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        surface: AppColors.background,
        surfaceTint: AppColors.background,
        onSurface: AppColors.bottomNavBackground,

        primary: AppColors.primary,
        onPrimary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.error,

        primaryContainer: AppColors.cardPrimary,
        onPrimaryContainer: AppColors.cardPrimary,

        outline: AppColors.border,
        outlineVariant: AppColors.divider,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: AppColors.cardPrimary,
        titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
        foregroundColor: AppColors.textPrimary,
      ),
      inputDecorationTheme: _inputDecorationTheme(
        textTheme: textTheme,
        isDark: false,
      ),
      iconTheme: IconThemeData(color: AppColors.iconSecondary),
      primaryIconTheme: IconThemeData(color: AppColors.iconPrimary),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.bottomNavBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        showUnselectedLabels: true,
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        backgroundColor: AppColors.cardPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.secondary,
        circularTrackColor: AppColors.secondary,
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: WidgetStatePropertyAll<Color>(AppColors.background),
        checkColor: WidgetStatePropertyAll<Color>(AppColors.background),
        side: BorderSide(color: AppColors.secondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final baseTheme = ThemeData.light();
    final textTheme = _getTextTheme(baseTheme.textTheme, true);
    return baseTheme.copyWith(
      textTheme: textTheme,
      elevatedButtonTheme: _getElevatedButtonTheme(textTheme, true),
      textButtonTheme: _getTextButtonTheme(true),
      outlinedButtonTheme: _getOutlineButtonTheme(true),
      scaffoldBackgroundColor: AppColors.dBackground,
      primaryColor: AppColors.dPrimary,
      colorScheme: const ColorScheme.light(
        surface: AppColors.dBackground,
        surfaceTint: AppColors.dBackground,
        onSurface: AppColors.dBottomNavBackground,

        primary: AppColors.dPrimary,
        onPrimary: AppColors.dPrimary,
        secondary: AppColors.dSecondary,
        tertiary: AppColors.dTertiary,
        error: AppColors.dError,

        primaryContainer: AppColors.dCardPrimary,
        onPrimaryContainer: AppColors.dCardPrimary,

        outline: AppColors.dBorder,
        outlineVariant: AppColors.divider,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: AppColors.dCardPrimary,
        titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
          color: AppColors.dTextPrimary,
        ),
        foregroundColor: AppColors.dTextPrimary,
      ),
      inputDecorationTheme: _inputDecorationTheme(
        textTheme: textTheme,
        isDark: false,
      ),
      iconTheme: IconThemeData(color: AppColors.dIconSecondary),
      primaryIconTheme: IconThemeData(color: AppColors.dIconPrimary),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.dBottomNavBackground,
        selectedItemColor: AppColors.dPrimary,
        unselectedItemColor: AppColors.dTextSecondary,
        selectedLabelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.dPrimary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        showUnselectedLabels: true,
      ),
      dialogTheme: baseTheme.dialogTheme.copyWith(
        backgroundColor: AppColors.dCardPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.dTextPrimary,
        ),
        contentTextStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.dTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.dSecondary,
        circularTrackColor: AppColors.dSecondary,
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: WidgetStatePropertyAll<Color>(AppColors.dBackground),
        checkColor: WidgetStatePropertyAll<Color>(AppColors.dBackground),
        side: BorderSide(color: AppColors.dSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        ),
      ),
    );
  }

  //------------------Button Theme------------------//
  static const _buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSizes.paddingLarge,
    vertical: AppSizes.paddingSmall,
  );
  static const _buttonDensity = VisualDensity(horizontal: 1, vertical: 1);

  static _getElevatedButtonTheme(TextTheme baseTextTheme, bool isDark) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: _buttonPadding,
        visualDensity: _buttonDensity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        textStyle: baseTextTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static _getTextButtonTheme(bool isDark) => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: _buttonPadding,
      visualDensity: _buttonDensity,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
    ),
  );

  static _getOutlineButtonTheme(bool isDark) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      visualDensity: _buttonDensity,
      padding: _buttonPadding,
      side: BorderSide(color: AppColors.primary),
      foregroundColor: AppColors.textPrimary,
    ),
  );

  static InputDecorationTheme _inputDecorationTheme({
    TextTheme? textTheme,
    bool isDark = false,
  }) {
    final baseTextTheme = textTheme;
    final backgroundColor = isDark
        ? AppColors.dInputBackground
        : AppColors.inputBackground;
    final borderColor = isDark ? AppColors.dBorder : AppColors.border;

    final enabledColor = borderColor;
    final focusColor = isDark ? AppColors.dPrimary : AppColors.primary;
    final errorColor = isDark ? AppColors.dError : AppColors.error;
    final disabledColor = isDark
        ? AppColors.dDisabledBorder
        : AppColors.disabledBorder;
    final hintColor = isDark ? AppColors.dTextHint : AppColors.dTextHint;

    OutlineInputBorder border({Color? color}) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.radiusSmall),
        ),
        borderSide: BorderSide(width: 1, color: color ?? borderColor),
      );
    }

    return InputDecorationTheme(
      contentPadding: const EdgeInsets.fromLTRB(12, 16, 10, 16),
      isDense: true,
      isCollapsed: true,
      filled: true,
      fillColor: backgroundColor,
      border: border(),
      //Enabled Border
      enabledBorder: border(color: enabledColor),

      //Focus Border
      focusedBorder: border(color: focusColor),

      //Error Border
      errorBorder: border(color: errorColor),

      //Error Focus Border
      focusedErrorBorder: border(color: focusColor),

      // Disabled Border
      disabledBorder: border(color: disabledColor),
      floatingLabelStyle: baseTextTheme?.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      hintStyle: baseTextTheme?.bodyMedium?.copyWith(
        fontWeight: FontWeight.normal,
        color: hintColor,
      ),
      counterStyle: baseTextTheme?.bodySmall,
      prefixIconConstraints: BoxConstraints(
        minHeight: AppSizes.iconSizeSmall + 4,
        minWidth: AppSizes.iconSizeSmall + 4,
      ),
    );
  }

  static TextTheme _getTextTheme(TextTheme baseTextTheme, bool isDark) {
    final color = isDark ? AppColors.dTextPrimary : AppColors.textPrimary;
    final colorSecondary = isDark
        ? AppColors.dTextSecondary
        : AppColors.textSecondary;
    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontFamily: _fontFamily,
        fontSize: 16,
        color: color,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontFamily: _fontFamily,
        fontSize: 16,
        color: color,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontFamily: _fontFamily,
        color: AppColors.textSecondary,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontFamily: _fontFamily,
        color: color,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontFamily: _fontFamily,
        color: color,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontFamily: _fontFamily,
        color: colorSecondary,
      ),
    );
  }
}
