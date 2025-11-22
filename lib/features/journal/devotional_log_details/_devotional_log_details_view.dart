import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../_journal_view_model.dart';
import '_devotional_log_details_state.dart';
import '_devotional_log_details_view_model.dart';

class DevotionalLogDetailsView extends ConsumerStatefulWidget {
  final int id;

  const DevotionalLogDetailsView({super.key, required this.id});

  @override
  ConsumerState<DevotionalLogDetailsView> createState() =>
      _DevotionalLogDetailsViewState();
}

class _DevotionalLogDetailsViewState
    extends ConsumerState<DevotionalLogDetailsView> {
  late TextEditingController _noteController;
  bool _isVersesExpanded = true;
  bool _isReflectionExpanded = true;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = ref.watch(devotionalLogDetailsViewModelProvider(widget.id));
    _noteController.text = state.editedNote ?? state.devotionalLog?.note ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(devotionalLogDetailsViewModelProvider(widget.id));
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            DetailsPageHeader(
              title: lang.journalEntry,
              action: MenuHeaderAction(
                onEdit: () => _handleEdit(context),
                onDelete: () => _handleDelete(context, theme, lang),
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
                  : state.devotionalLog == null
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
      devotionalLogDetailsViewModelProvider(widget.id).notifier,
    );
    vm.startEditing();
  }

  void _handleDelete(BuildContext context, ThemeData theme, S lang) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context: context,
      iconPath: AppIcons.sadPetImage,
    );
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
      devotionalLogDetailsViewModelProvider(widget.id).notifier,
    );
    final journalVm = ref.read(journalViewModelProvider.notifier);

    LoadingDialog.show(context: context, message: lang.deleting);

    final success = await vm.deleteDevotionalLog();

    if (context.mounted) {
      LoadingDialog.hide(context);

      if (success) {
        journalVm.loadDevotionalLogs();
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
      devotionalLogDetailsViewModelProvider(widget.id).notifier,
    );
    final state = ref.read(devotionalLogDetailsViewModelProvider(widget.id));
    final journalVm = ref.read(journalViewModelProvider.notifier);

    final originalNote = state.devotionalLog?.note?.trim() ?? '';
    final editedNote = state.editedNote?.trim() ?? '';

    if (originalNote == editedNote) {
      vm.cancelEditing();
      _noteController.text = originalNote;
      if (context.mounted) {
        vm.cancelEditing();
        _noteController.text = originalNote;
      }
      return;
    }

    LoadingDialog.show(context: context, message: lang.saving);

    final success = await vm.updateDevotionalLog();

    if (context.mounted) {
      LoadingDialog.hide(context);

      if (success) {
        journalVm.loadDevotionalLogs();
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
    DevotionalLogDetailsState state,
    S lang,
  ) {
    final log = state.devotionalLog!;
    final devotional = log.devotional;

    String formatDateString(String? date) {
      if (date == null || date.isEmpty) return '';
      try {
        final parsedDate = DateTime.parse(date);
        return DateFormat('MMMM d, yyyy', 'en').format(parsedDate);
      } catch (e) {
        return date;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (devotional?.verses != null && devotional!.verses!.isNotEmpty) ...[
            VerseContent(verseRelationships: devotional.verses!),
            const SizedBox(height: AppSizes.spacingLarge),
          ],
          if (state.isEditing || (log.note != null && log.note!.isNotEmpty)) ...[
            NoteDisplay(
              note: log.note,
              isEditing: state.isEditing,
              controller: _noteController,
              onChanged: (value) {
                final vm = ref.read(
                  devotionalLogDetailsViewModelProvider(widget.id).notifier,
                );
                vm.updateEditedNote(value);
              },
              onSave: () => _performUpdate(context, theme, lang),
              onCancel: () {
                final vm = ref.read(
                  devotionalLogDetailsViewModelProvider(widget.id).notifier,
                );
                final state = ref.read(
                  devotionalLogDetailsViewModelProvider(widget.id),
                );
                vm.cancelEditing();
                _noteController.text = state.devotionalLog?.note ?? '';
              },
              isSaving: state.isUpdating,
            ),
            const SizedBox(height: AppSizes.spacingLarge),
          ],
          if (devotional?.title != null && devotional!.title!.isNotEmpty) ...[
            Text(devotional.title!, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSizes.spacingSmall),
          ],
          if (devotional?.tags != null && devotional!.tags!.isNotEmpty) ...[
            Wrap(
              spacing: AppSizes.spacingSmall,
              runSpacing: AppSizes.spacingSmall,
              children: devotional.tags!.map((tagRelationship) {
                final tag = tagRelationship.tag;
                if (tag == null) return const SizedBox.shrink();
                final tagName = tag.translations?.isNotEmpty == true
                    ? tag.translations!.first.name ?? ''
                    : '';
                if (tagName.isEmpty) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: AppSizes.paddingXXSmall,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tag.icon != null && tag.icon!.isNotEmpty) ...[
                        Text(tag.icon!, style: theme.textTheme.bodyMedium),
                        const SizedBox(width: AppSizes.spacingXXSmall),
                      ],
                      Text(
                        tagName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: theme.textTheme.titleSmall?.fontWeight,
                          color: theme.textTheme.labelSmall?.color,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
          ],
          if (devotional?.content != null &&
              devotional!.content!.isNotEmpty) ...[
            Text(devotional.content!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSizes.spacingLarge),
          ],
          if (devotional?.reflection != null &&
              devotional!.reflection!.isNotEmpty) ...[
            ExpandableSection(
              title: lang.keyLearnings,
              isExpanded: _isReflectionExpanded,
              onToggle: () {
                setState(() {
                  _isReflectionExpanded = !_isReflectionExpanded;
                });
              },
              content: Text(devotional.reflection!, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
          ],
          const SizedBox(height: AppSizes.spacingMedium),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatDateString(log.createdAt?.toIso8601String()),
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


}
