import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class InputValidations {
  static String? validateName(BuildContext context, String? value) {
    final lang = S.of(context);
    if (value == null || value.isEmpty) {
      return lang.thisFieldIsRequired;
    }
    if (value.length < 3) {
      return lang.nameMustBeAtLeast3CharactersLong;
    }
    return null; // ✅ Valid Name
  }

  static String? validateEmail(BuildContext context, String? value) {
    final lang = S.of(context);
    if (value == null || value.isEmpty) {
      return lang.thisFieldIsRequired;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return lang.invalidEmail;
    }

    return null; // ✅ Valid Email
  }

  static String? validatePassword(BuildContext context, String? value) {
    final lang = S.of(context);
    if (value == null || value.isEmpty) {
      return lang.thisFieldIsRequired;
    }

    if (value.length < 6) {
      return '${lang.passwordMustContainAtLeast} ${lang.passMinCharacters}';
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return '${lang.passwordMustContainAtLeast} ${lang.passOneLetter}';
    }

    if (!RegExp(r'\d').hasMatch(value)) {
      return '${lang.passwordMustContainAtLeast} ${lang.passOneNumber}';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return '${lang.passwordMustContainAtLeast} ${lang.passOneUppercaseLetter}';
    }
    return null; // ✅ Valid Password
  }

  static String? validatePhoneNumber(BuildContext context, String? value) {
    final lang = S.of(context);

    if (value == null || value.isEmpty) {
      return lang.thisFieldIsRequired;
    }
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^\+?\d+$').hasMatch(cleanedValue)) {
      return lang.phoneNumberDigitsError;
    }
    final lengthWithoutPlus = cleanedValue.startsWith('+')
        ? cleanedValue.substring(1).length
        : cleanedValue.length;
    if (lengthWithoutPlus < 10 || lengthWithoutPlus > 15) {
      return lang.phoneNumberLengthError;
    }

    return null; // ✅ Valid Phone
  }
}
