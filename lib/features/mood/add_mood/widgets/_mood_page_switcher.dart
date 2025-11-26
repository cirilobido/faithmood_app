import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../_add_mood_state.dart';
import '../pages/_page_emotional_moods.dart';
import '../pages/_page_spiritual_moods.dart';
import '../pages/_page_add_note.dart';

class MoodPageSwitcher extends ConsumerWidget {
  final AddMoodState state;
  final Function(Mood) onEmotionalMoodSelected;
  final Function(Mood) onSpiritualMoodSelected;
  final Function(String) onNoteChanged;

  const MoodPageSwitcher({
    super.key,
    required this.state,
    required this.onEmotionalMoodSelected,
    required this.onSpiritualMoodSelected,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeInOut,
      child: _buildPage(context, ref, state.currentPage),
    );
  }

  Widget _buildPage(BuildContext context, WidgetRef ref, int index) {
    switch (index) {
      case 0:
        return PageEmotionalMoods(
          key: const ValueKey(0),
          state: state,
          onMoodSelected: onEmotionalMoodSelected,
        );
      case 1:
        return PageSpiritualMoods(
          key: const ValueKey(1),
          state: state,
          onMoodSelected: onSpiritualMoodSelected,
        );
      case 2:
        return PageAddNote(
          key: const ValueKey(2),
          note: state.note,
          onNoteChanged: onNoteChanged,
        );
      default:
        return const SizedBox();
    }
  }
}

