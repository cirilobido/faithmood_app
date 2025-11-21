import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
            _buildHeader(context, theme, lang),
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

  Widget _buildHeader(BuildContext context, ThemeData theme, S lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingMedium,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            splashColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: SvgPicture.asset(
              AppIcons.arrowLeftIcon,
              width: AppSizes.iconSizeMedium,
              colorFilter: ColorFilter.mode(
                theme.primaryIconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Text(
              lang.journalEntry,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: AppSizes.iconSizeNormal,
            child: Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                iconSize: AppSizes.iconSizeNormal,
                splashRadius: AppSizes.iconSizeNormal / 2,
                icon: SvgPicture.asset(
                  AppIcons.moreVerticalIcon,
                  width: AppSizes.iconSizeNormal,
                  height: AppSizes.iconSizeNormal,
                  colorFilter: ColorFilter.mode(
                    theme.primaryIconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _handleEdit(context);
                  } else if (value == 'delete') {
                    _handleDelete(context, theme, lang);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: AppSizes.iconSizeNormal,
                          color: theme.iconTheme.color,
                        ),
                        const SizedBox(width: AppSizes.spacingSmall),
                        Text(
                          lang.edit,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: AppSizes.iconSizeNormal,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: AppSizes.spacingSmall),
                        Text(
                          lang.delete,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    final vm = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId).notifier);
    final state = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId));
    vm.startEditing();
    _noteController.text = state.moodSession?.note ?? '';
  }

  void _handleDelete(BuildContext context, ThemeData theme, S lang) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text(
            lang.deleteMoodEntry,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          content: Text(
            lang.deleteMoodEntryMessage,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          actions: [
            Column(
              children: [
                CustomButton(
                  title: lang.confirm,
                  type: ButtonType.error,
                  isShortText: true,
                  onTap: () async {
                    Navigator.of(dialogContext).pop();
                    await _performDelete(context, theme, lang);
                  },
                ),
                const SizedBox(height: AppSizes.spacingSmall),
                CustomButton(
                  title: lang.cancel,
                  type: ButtonType.neutral,
                  style: CustomStyle.outlined,
                  isShortText: true,
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDelete(BuildContext context, ThemeData theme, S lang) async {
    final vm = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId).notifier);
    final journalVm = ref.read(journalViewModelProvider.notifier);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingIndicator(),
                const SizedBox(height: AppSizes.spacingMedium),
                Text(
                  lang.deleting,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );

    final success = await vm.deleteMoodSession();

    if (context.mounted) {
      Navigator.of(context).pop();

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

  Future<void> _performUpdate(BuildContext context, ThemeData theme, S lang) async {
    final vm = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId).notifier);
    final state = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId));
    final journalVm = ref.read(journalViewModelProvider.notifier);

    final originalNote = state.moodSession?.note?.trim() ?? '';
    final editedNote = state.editedNote?.trim() ?? '';

    if (originalNote == editedNote) {
      vm.cancelEditing();
      _noteController.text = originalNote;
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingIndicator(),
                const SizedBox(height: AppSizes.spacingMedium),
                Text(
                  lang.saving,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );

    final success = await vm.updateMoodSession();

    if (context.mounted) {
      Navigator.of(context).pop();

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
          _buildFeelingAndSpiritCard(
            context,
            theme,
            lang,
            emotionalMoodIcon,
            emotionalMoodName,
            spiritualMoodIcon,
            spiritualMoodName,
          ),
          if (state.isEditing) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            Text(lang.myThoughts, style: theme.textTheme.titleMedium),
            InputField(
              controller: _noteController,
              isMultiline: true,
              hintText: lang.myThoughts,
              onChanged: (value) {
                final vm = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId).notifier);
                vm.updateEditedNote(value);
              },
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Column(
              children: [
                CustomButton(
                  title: lang.save,
                  type: ButtonType.primary,
                  isLoading: state.isUpdating,
                  isShortText: true,
                  onTap: () => _performUpdate(context, theme, lang),
                ),
                const SizedBox(height: AppSizes.spacingSmall),
                CustomButton(
                  title: lang.cancel,
                  type: ButtonType.neutral,
                  style: CustomStyle.outlined,
                  isShortText: true,
                  onTap: () {
                    final vm = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId).notifier);
                    final state = ref.read(moodEntryDetailsViewModelProvider(widget.sessionId));
                    vm.cancelEditing();
                    _noteController.text = state.moodSession?.note ?? '';
                  },
                ),
              ],
            ),
          ] else if (session.note != null && session.note!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            Text(lang.myThoughts, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSizes.spacingSmall),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(session.note!, style: theme.textTheme.bodyLarge),
            ),
          ],
          if (aiVerse != null) ...[
            const SizedBox(height: AppSizes.spacingLarge),
            _buildExpandableSection(
              context,
              theme,
              lang.verseForTheDay,
              _isVerseExpanded,
              () {
                setState(() {
                  _isVerseExpanded = !_isVerseExpanded;
                });
              },
              _buildVerseContent(context, theme, session.aiVerse!, userLang),
            ),
          ],
          if (aiReflection != null && aiReflection.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            _buildExpandableSection(
              context,
              theme,
              lang.todayEncouragement,
              _isReflectionExpanded,
              () {
                setState(() {
                  _isReflectionExpanded = !_isReflectionExpanded;
                });
              },
              Text(
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

  Widget _buildExpandableSection(
    BuildContext context,
    ThemeData theme,
    String title,
    bool isExpanded,
    VoidCallback onTap,
    Widget content,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: AppSizes.borderWithSmall,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: AppSizes.borderWithSmall,
              color: theme.colorScheme.outlineVariant,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: content,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerseContent(
    BuildContext context,
    ThemeData theme,
    Verse aiVerse,
    String userLang,
  ) {
    final verseText = aiVerse.translations?.first.text ?? '';
    final verseRef = aiVerse.translations?.first.ref ?? '';

    if (verseText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(verseText, style: theme.textTheme.bodyLarge),
          if (verseRef.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingXSmall),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                verseRef,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
