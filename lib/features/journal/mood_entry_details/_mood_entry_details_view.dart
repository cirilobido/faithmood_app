import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_journal_view_model.dart';
import '_mood_entry_details_state.dart';
import '_mood_entry_details_view_model.dart';

class MoodEntryDetailsView extends ConsumerStatefulWidget {
  final String sessionId;

  const MoodEntryDetailsView({super.key, required this.sessionId});

  @override
  ConsumerState<MoodEntryDetailsView> createState() =>
      _MoodEntryDetailsViewState();
}

class _MoodEntryDetailsViewState extends ConsumerState<MoodEntryDetailsView> {
  bool _isVerseExpanded = true;
  bool _isReflectionExpanded = true;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      moodEntryDetailsViewModelProvider(widget.sessionId),
    );
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            DetailsPageHeader(
              title: lang.journalEntry,
              onBack: () async {
                final vm = ref.read(
                  moodEntryDetailsViewModelProvider(widget.sessionId).notifier,
                );
                await vm.stopTTS();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              action: MoodEntryOptionsHeaderAction(
                onEdit: () => _handleEdit(context),
                onDelete: () => _handleDelete(context, theme, lang),
                isPlaying: state.isPlaying,
                isPaused: state.isPaused,
                onTtsTap: () async {
                  final vm = ref.read(
                    moodEntryDetailsViewModelProvider(widget.sessionId).notifier,
                  );
                  if (state.isPlaying) {
                    await vm.pauseTTS();
                  } else if (state.isPaused) {
                    await vm.playTTS();
                  } else {
                    await vm.playTTS();
                  }
                  if (context.mounted) {
                    TtsPlayerDialog.showMoodEntry(
                      context: context,
                      sessionId: widget.sessionId,
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: LoadingIndicator())
                  : state.error
                  ? ErrorState(
                      message: lang.unableToLoadMoodEntry,
                      imagePath: AppIcons.sadPetImage,
                    )
                  : state.moodSession == null
                  ? EmptyState(message: lang.noJournalEntries)
                  : _buildContent(context, theme, state, lang),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    final vm = ref.read(
      moodEntryDetailsViewModelProvider(widget.sessionId).notifier,
    );
    final state = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId));
    vm.startEditing();
    _noteController.text = state.moodSession?.note ?? '';
  }

  void _handleDelete(BuildContext context, ThemeData theme, S lang) async {
    final confirmed = await DeleteConfirmationDialog.show(context: context);
    if (confirmed == true) {
      await _performDelete(context, theme, lang);
    }
  }

  Future<void> _performDelete(
    BuildContext context,
    ThemeData theme,
    S lang,
  ) async {
    final vm = ref.read(
      moodEntryDetailsViewModelProvider(widget.sessionId).notifier,
    );
    final journalVm = ref.read(journalViewModelProvider.notifier);

    LoadingDialog.show(context: context, message: lang.deleting);

    final success = await vm.deleteMoodSession();

    if (context.mounted) {
      LoadingDialog.hide(context);

      if (success) {
        journalVm.loadMoodSessions();
        if (context.mounted) {
          Navigator.of(context).pop();
          CustomSnackBar.show(
            context,
            message: lang.moodEntryDeleted,
            backgroundColor: theme.colorScheme.primary,
          );
        }
      } else {
        if (context.mounted) {
          CustomSnackBar.show(
            context,
            message: lang.errorDeletingMoodEntry,
            backgroundColor: theme.colorScheme.error,
          );
        }
      }
    }
  }

  Future<void> _performUpdate(
    BuildContext context,
    ThemeData theme,
    S lang,
  ) async {
    final vm = ref.read(
      moodEntryDetailsViewModelProvider(widget.sessionId).notifier,
    );
    final state = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId));
    final journalVm = ref.read(journalViewModelProvider.notifier);

    final originalNote = state.moodSession?.note?.trim() ?? '';
    final editedNote = state.editedNote?.trim() ?? '';

    if (originalNote == editedNote) {
      vm.cancelEditing();
      _noteController.text = originalNote;
      return;
    }

    LoadingDialog.show(context: context, message: lang.saving);

    final success = await vm.updateMoodSession();

    if (context.mounted) {
      LoadingDialog.hide(context);

      if (success) {
        journalVm.loadMoodSessions();
        if (context.mounted) {
          CustomSnackBar.show(
            context,
            message: lang.moodEntryUpdated,
            backgroundColor: theme.colorScheme.primary,
          );
        }
      } else {
        if (context.mounted) {
          CustomSnackBar.show(
            context,
            message: lang.errorUpdatingMoodEntry,
            backgroundColor: theme.colorScheme.error,
          );
        }
      }
    }
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    MoodEntryDetailsState state,
    S lang,
  ) {
    final auth = ref.read(authProvider);
    final userLang = auth.user?.lang?.name ?? 'en';
    final session = state.moodSession!;
    final emotionalMood = session.emotional?.mood;
    final spiritualMood = session.spiritual?.mood;

    String getMoodName(Mood? mood) {
      if (mood == null) return '';
      return mood.translations?.first.name ?? mood.name ?? '';
    }

    String getMoodIcon(Mood? mood) {
      return mood?.icon ?? '';
    }

    final emotionalMoodName = getMoodName(emotionalMood);
    final spiritualMoodName = getMoodName(spiritualMood);
    final emotionalMoodIcon = getMoodIcon(emotionalMood);
    final spiritualMoodIcon = getMoodIcon(spiritualMood);

    String formatDateTime(DateTime? date) {
      if (date == null) return '';
      return DateFormat('MMMM d, yyyy', 'en').format(date);
    }

    final aiReflection =
        session.emotional?.aiReflection ?? session.spiritual?.aiReflection;
    final aiVerse = session.aiVerse;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aiVerse != null) ...[
            VerseContent(
              verse: session.aiVerse!,
              useStyledContainer: true,
              userLang: userLang,
            ),
          ],
          ...[
            const SizedBox(height: AppSizes.spacingLarge),
            _buildFeelingAndSpiritCard(
              context,
              theme,
              lang,
              emotionalMoodIcon,
              emotionalMoodName,
              spiritualMoodIcon,
              spiritualMoodName,
            ),
          ],
          if (state.isEditing ||
              (session.note != null && session.note!.isNotEmpty)) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            NoteDisplay(
              note: session.note,
              isEditing: state.isEditing,
              controller: _noteController,
              onChanged: (value) {
                final vm = ref.read(
                  moodEntryDetailsViewModelProvider(widget.sessionId).notifier,
                );
                vm.updateEditedNote(value);
              },
              onSave: () => _performUpdate(context, theme, lang),
              onCancel: () {
                final vm = ref.read(
                  moodEntryDetailsViewModelProvider(widget.sessionId).notifier,
                );
                final state = ref.read(
                  moodEntryDetailsViewModelProvider(widget.sessionId),
                );
                vm.cancelEditing();
                _noteController.text = state.moodSession?.note ?? '';
              },
              isSaving: state.isUpdating,
            ),
          ],
          if (aiReflection != null && aiReflection.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            ExpandableSection(
              title: lang.todayEncouragement,
              isExpanded: _isReflectionExpanded,
              onToggle: () {
                setState(() {
                  _isReflectionExpanded = !_isReflectionExpanded;
                });
              },
              content: Text(
                aiReflection,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSizes.spacingMedium),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatDateTime(session.date),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.labelSmall?.color,
                fontWeight: theme.textTheme.titleSmall?.fontWeight,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacingLarge),
        ],
      ),
    );
  }

  Widget _buildFeelingAndSpiritCard(
    BuildContext context,
    ThemeData theme,
    S lang,
    String emotionalIcon,
    String emotionalName,
    String spiritualIcon,
    String spiritualName,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: Column(
        children: [
          _buildMoodRow(theme, lang.feeling, emotionalIcon, emotionalName),
          if (spiritualName.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            _buildMoodRow(theme, lang.spirit, spiritualIcon, spiritualName),
          ],
        ],
      ),
    );
  }

  Widget _buildMoodRow(
    ThemeData theme,
    String label,
    String icon,
    String name,
  ) {
    return Row(
      children: [
        if (icon.isNotEmpty) ...[
          Container(
            width: AppSizes.iconSizeXLarge,
            height: AppSizes.iconSizeXLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(icon, style: theme.textTheme.titleLarge)),
          ),
          const SizedBox(width: AppSizes.spacingSmall),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                  fontWeight: theme.textTheme.titleLarge?.fontWeight,
                ),
              ),
              Text(name, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      ],
    );
  }
}
