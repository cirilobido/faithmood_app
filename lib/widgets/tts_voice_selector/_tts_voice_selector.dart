import 'package:flutter/material.dart';

import '../../core/core_exports.dart';

class TtsVoiceSelector extends StatelessWidget {
  final List<Map<String, String>> voices;
  final String? selectedVoiceId;
  final Function(String name, String locale) onVoiceSelected;

  const TtsVoiceSelector({
    super.key,
    required this.voices,
    this.selectedVoiceId,
    required this.onVoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (voices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Text(
          'No voices available',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...voices.map((voice) {
          final name = voice['name'] ?? '';
          final locale = voice['locale'] ?? '';
          final voiceId = '$name-$locale';
          final isSelected = selectedVoiceId == voiceId;

          return ListTile(
            title: Text(
              name,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? isDark
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.primary
                    : null,
              ),
            ),
            subtitle: Text(
              locale,
              style: theme.textTheme.bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              onVoiceSelected(name, locale);
            },
          );
        }).toList(),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required List<Map<String, String>> voices,
    String? selectedVoiceId,
    required Function(String name, String locale) onVoiceSelected,
  }) {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Voice',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: TtsVoiceSelector(
              voices: voices,
              selectedVoiceId: selectedVoiceId,
              onVoiceSelected: onVoiceSelected,
            ),
          ),
        );
      },
    );
  }
}

