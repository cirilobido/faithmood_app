import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import '../../../core/core_exports.dart';

class CheckBoxListSelector extends StatefulWidget {
  final Map<String, String> options; // key: internal ID, value: label
  final List<String>? initialSelectedKeys;
  final ValueChanged<List<String>> onChanged;
  final double separatorHeight;

  const CheckBoxListSelector({
    super.key,
    required this.options,
    required this.onChanged,
    this.initialSelectedKeys,
    this.separatorHeight = AppSizes.spacingMedium,
  });

  @override
  State<CheckBoxListSelector> createState() => _CheckBoxListSelectorState();
}

class _CheckBoxListSelectorState extends State<CheckBoxListSelector> {
  late final Map<String, bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final entry in widget.options.entries)
        entry.key: widget.initialSelectedKeys?.contains(entry.key) ?? false,
    };
  }

  void _onItemTap(String key, bool value, BuildContext context) {
    triggerHapticFeedback(HapticsType.selection, context: context);
    setState(() => _selected[key] = value);
    widget.onChanged(
      _selected.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList(growable: false),
    );
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
    final selected = _selected[key] ?? false;
    final theme = Theme.of(context);

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
        child: CheckboxListTile(
          checkboxScaleFactor: 1.1,
          key: ValueKey(key),
          value: selected,
          onChanged: (value) => _onItemTap(key, value ?? false, context),
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
            return theme.colorScheme.surface;
          }),
          activeColor: theme.colorScheme.secondary,
          checkColor: theme.colorScheme.secondary,
          side: BorderSide(color: theme.colorScheme.outline, width: 1),
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXXSmall),
          ),
          visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}
