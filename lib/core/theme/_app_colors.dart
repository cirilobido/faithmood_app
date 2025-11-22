import 'package:flutter/material.dart';

abstract class AppColors {
  //---------------Light Colors---------------//
  static const background = Color(0xfff8f9fa);
  static const bottomNavBackground = Color(0xFFFFFFFF);
  static const cardPrimary = Color(0xffFFFFFF);

  static const primary = Color(0xff6D9DC5);
  static const secondary = Color(0xffBFD8B8);
  static const tertiary = Color(0xffE8C7A1);

  static const error = Color(0xffE57373);
  static const success = Color(0xff81C784);
  static const pending = Color(0xffFFD54F);
  static const info = Color(0xff64B5F6);

  static const textPrimary = Color(0xff2E2E2E);
  static const textSecondary = Color(0xff6E6E6E);
  static const textHint = Color(0xff9E9E9E);

  static const iconPrimary = Color(0xFF212121);
  static const iconSecondary = Color(0xFF757575);
  static const iconTertiary = Color(0xFFD5D5D5);

  static const inputBorder = Color(0xffE0E0E0);
  static const inputBackground = Color(0xffffffff);

  static const border = Color(0xffE0E0E0);
  static const divider = Color(0xffE5E5E5);

  static const disabledBackground = Color(0xffE0E0E0);
  static const disabledText = Color(0xff9E9E9E);
  static const disabledBorder = Color(0xffD6D6D6);


  //---------------Dark Colors---------------//
  static const dBackground = Color(0xff121212);
  static const dBottomNavBackground = Color(0xFF1E1E1E);
  static const dCardPrimary = Color(0xff1E1E1E);

  static const dPrimary = Color(0xff6D9DC5);
  static const dSecondary = Color(0xffA9CBB7);
  static const dTertiary = Color(0xffEBCBA7);

  static const dError = Color(0xffFF6F61);
  static const dSuccess = Color(0xff81C784);
  static const dPending = Color(0xffFFD54F);
  static const dInfo = Color(0xff64B5F6);

  static const dTextPrimary = Color(0xffF5F5F5);
  static const dTextSecondary = Color(0xffB0B0B0);
  static const dTextHint = Color(0xff888888);

  static const dIconPrimary = Color(0xFFE0E0E0);
  static const dIconSecondary = Color(0xFF9E9E9E);
  static const dIconTertiary = Color(0xFF3B3B3B);

  static const dInputBorder = Color(0xff2E2E2E);
  static const dInputBackground = Color(0xff1C1C1C);

  static const dBorder = Color(0xff2E2E2E);
  static const dDivider = Color(0xff2A2A2A);

  static const dDisabledBackground = Color(0xff2A2A2A);
  static const dDisabledText = Color(0xff777777);
  static const dDisabledBorder = Color(0xff3A3A3A);


  //---------------Extra Colors---------------//
  static const progressGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [background, cardPrimary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientPremium = LinearGradient(
    colors: [tertiary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
