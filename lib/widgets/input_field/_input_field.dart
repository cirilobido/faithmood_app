// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart';
import '../../../core/core_exports.dart';

enum FieldTypeValidation { text, email, password, name, phone }

enum FieldType { text, date }

class InputField extends StatelessWidget {
  final String? label;
  final String? initialValue;
  final bool required;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? enabled;
  final bool? readOnly;
  final bool? hideCounter;
  final String? hintText;
  final String? errorText;

  // Prefix Icon variables
  final IconData? prefixIconData;
  final Widget? prefixIconWidget;

  // Suffix Icon variables
  final IconData? suffixIconData;
  final Widget? suffixIconWidget;

  final FormFieldValidator<String>? customValidator;
  final AutovalidateMode? autoValidateMode;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final List<FieldTypeValidation>? validations;
  final int? maxLength;
  final FieldType? fieldType;
  final bool? extraSpace;
  final bool? isMultiline;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final TextCapitalization? textCapitalization;

  const InputField({
    super.key,
    this.label,
    this.initialValue,
    this.labelStyle,
    this.style,
    this.required = false,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.hideCounter = true,
    this.hintText,
    this.errorText,
    this.prefixIconData,
    this.prefixIconWidget,
    this.suffixIconData,
    this.suffixIconWidget,
    this.customValidator,
    this.autoValidateMode,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction,
    this.validations,
    this.maxLength,
    this.fieldType = FieldType.text,
    this.extraSpace = true,
    this.isMultiline = false,
    this.onTap,
    this.inputFormatters,
    this.textAlign,
    this.textCapitalization = TextCapitalization.none,
  });

  Widget? _buildIcon({
    required BuildContext context,
    IconData? iconData,
    Widget? iconWidget,
  }) {
    final theme = Theme.of(context);
    if (iconWidget != null) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppSizes.paddingSmall,
          right: AppSizes.paddingXSmall,
        ),
        child: iconWidget,
      );
    }
    if (iconData != null) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppSizes.paddingSmall,
          right: AppSizes.paddingXSmall,
        ),
        child: Icon(
          iconData,
          size: AppSizes.iconSizeRegular,
          color: theme.iconTheme.color,
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              text: label,
              style:
                  labelStyle ??
                  theme.textTheme.labelLarge?.copyWith(
                    color: theme.textTheme.labelSmall?.color
                  ),
              children: [
                if (required)
                  TextSpan(
                    text: ' *',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        (label != null && extraSpace!)
            ? const SizedBox(height: AppSizes.spacingSmall)
            : const SizedBox(height: AppSizes.spacingXSmall),
        TextFormField(
          onTapAlwaysCalled: onTap != null,
          onTap: onTap,
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly! || fieldType == FieldType.date,
          maxLength: maxLength,
          minLines: isMultiline! ? 6 : 1,
          maxLines: isMultiline! ? 6 : 1,
          textAlign: textAlign ?? TextAlign.start,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization!,
          decoration: InputDecoration(
            hintText: hintText,
            counterText: hideCounter! ? '' : null,
            errorText: errorText,
            prefixIcon: _buildIcon(
              context: context,
              iconData: prefixIconData,
              iconWidget: prefixIconWidget,
            ),
            suffixIcon: _buildIcon(
              context: context,
              iconData: suffixIconData,
              iconWidget: suffixIconWidget,
            ),
          ),
          style: style ?? theme.textTheme.bodyLarge,
          validator: (value) {
            final lang = S.of(context);
            if (required && (value == null || value.trim().isEmpty)) {
              return lang.thisFieldIsRequired;
            }
            if (validations?.contains(FieldTypeValidation.email) ?? false) {
              return InputValidations.validateEmail(context, value);
            }
            if (validations?.contains(FieldTypeValidation.password) ?? false) {
              return InputValidations.validatePassword(context, value);
            }
            if (validations?.contains(FieldTypeValidation.name) ?? false) {
              return InputValidations.validateName(context, value);
            }
            if (validations?.contains(FieldTypeValidation.phone) ?? false) {
              return InputValidations.validatePhoneNumber(context, value);
            }
            if (customValidator != null) {
              return customValidator!(value);
            }
            return null;
          },
          autovalidateMode: autoValidateMode,
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
