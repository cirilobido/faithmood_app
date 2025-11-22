import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';

class LanguageBottomSheet extends StatelessWidget {
  final Lang? selectedLang;
  final ValueChanged<Lang?> onChanged;

  const LanguageBottomSheet({
    super.key,
    required this.onChanged,
    this.selectedLang,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = S.of(context);
    final langList = Lang.values;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lang.selectYourLanguage,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          ...langList.map((e) {
            final isSelected = selectedLang == e;
            return ListTile(
              title: Text(
                Lang.toTitle(value: e) ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? isDark ? theme.colorScheme.tertiary : theme.colorScheme.primary
                      : null,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onChanged(e);
              },
            );
          }),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required Lang? selectedLang,
    required ValueChanged<Lang?> onChanged,
  }) {
    final theme = Theme.of(context);
    return showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusNormal),
        ),
      ),
      builder: (_) => LanguageBottomSheet(
        selectedLang: selectedLang,
        onChanged: onChanged,
      ),
    );
  }
}
