import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import '../../../core/core_exports.dart';

class RadioListSelector extends StatefulWidget {
  final Map<String, String> options; // key: internal ID, value: label
  final String? initialSelectedKey;
  final ValueChanged<String> onChanged;
  final double separatorHeight;

  const RadioListSelector({
    super.key,
    required this.options,
    required this.onChanged,
    this.initialSelectedKey,
    this.separatorHeight = AppSizes.spacingMedium,
  });

  @override
  State<RadioListSelector> createState() => _RadioListSelectorState();
}

class _RadioListSelectorState extends State<RadioListSelector> {
  late String? _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.initialSelectedKey;
  }

  void _onItemTap(String key, BuildContext context) {
    triggerHapticFeedback(HapticsType.selection, context: context);
    setState(() => _selectedKey = key);
    widget.onChanged(key);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.options.length; i++) ...[
          _buildItem(theme, widget.options.entries.elementAt(i)),
          if (i < widget.options.length - 1)
            SizedBox(height: widget.separatorHeight),
        ],
      ],
    );
  }

  Widget _buildItem(ThemeData theme, MapEntry<String, String> entry) {
    final key = entry.key;
    final label = entry.value;
    final selected = key == _selectedKey;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingXSmall,
        horizontal: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: selected
            ? theme.colorScheme.secondary
            : theme.colorScheme.onSurface,
        border: Border.all(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: ListTileTheme(
        horizontalTitleGap: 4,
        child: RadioListTile<String>(
          key: ValueKey(key),
          value: key,
          groupValue: _selectedKey,
          onChanged: (_) => _onItemTap(key, context),
          title: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.onSurface;
            }
            return theme.colorScheme.outline;
          }),
          activeColor: theme.colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}
