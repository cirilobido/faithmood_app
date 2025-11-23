import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';

class ThemeModeBottomSheet extends StatelessWidget {
  final ThemeMode? selectedThemeMode;
  final ValueChanged<ThemeMode?> onChanged;

  const ThemeModeBottomSheet({
    super.key,
    required this.onChanged,
    this.selectedThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = S.of(context);
    final themeModes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lang.selectYourTheme,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          ...themeModes.map((mode) {
            final isSelected = selectedThemeMode == mode;
            String title;
            switch (mode) {
              case ThemeMode.light:
                title = lang.light;
                break;
              case ThemeMode.dark:
                title = lang.dark;
                break;
              case ThemeMode.system:
                title = lang.system;
                break;
            }
            return ListTile(
              title: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? isDark ? theme.colorScheme.tertiary : theme.colorScheme.primary
                      : null,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onChanged(mode);
              },
            );
          }),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required ThemeMode? selectedThemeMode,
    required ValueChanged<ThemeMode?> onChanged,
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
      builder: (_) => ThemeModeBottomSheet(
        selectedThemeMode: selectedThemeMode,
        onChanged: onChanged,
      ),
    );
  }
}

