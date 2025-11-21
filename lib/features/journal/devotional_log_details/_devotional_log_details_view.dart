import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
            _buildHeader(context, theme, lang, state.isEditing),
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

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    S lang,
    bool isEditing,
  ) {
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
    final vm = ref.read(
      devotionalLogDetailsViewModelProvider(widget.id).notifier,
    );
    vm.startEditing();
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
          icon: Image.asset(
            AppIcons.sadPetImage,
            height: AppSizes.dialogIconSize,
          ),
          actions: <Widget>[
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

  Future<void> _performDelete(
    BuildContext context,
    ThemeData theme,
    S lang,
  ) async {
    final vm = ref.read(
      devotionalLogDetailsViewModelProvider(widget.id).notifier,
    );
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
                Text(lang.deleting, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        );
      },
    );

    final success = await vm.deleteDevotionalLog();

    if (context.mounted) {
      Navigator.of(context).pop();

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
                Text(lang.saving, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        );
      },
    );

    final success = await vm.updateDevotionalLog();

    if (context.mounted) {
      Navigator.of(context).pop();

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
          if (state.isEditing) ...[
            Text(lang.myThoughts, style: theme.textTheme.titleMedium),
            InputField(
              controller: _noteController,
              isMultiline: true,
              hintText: lang.myThoughts,
              onChanged: (value) {
                final vm = ref.read(
                  devotionalLogDetailsViewModelProvider(widget.id).notifier,
                );
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
                    final vm = ref.read(
                      devotionalLogDetailsViewModelProvider(widget.id).notifier,
                    );
                    final state = ref.read(
                      devotionalLogDetailsViewModelProvider(widget.id),
                    );
                    vm.cancelEditing();
                    _noteController.text = state.devotionalLog?.note ?? '';
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingLarge),
          ] else if (log.note != null && log.note!.isNotEmpty) ...[
            Text(lang.myThoughts, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSizes.spacingSmall),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(log.note!, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
          ],
          if (devotional?.title != null && devotional!.title!.isNotEmpty) ...[
            Text(devotional.title!, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSizes.spacingMedium),
          ],
          if (devotional?.content != null &&
              devotional!.content!.isNotEmpty) ...[
            Text(devotional.content!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSizes.spacingLarge),
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
          if (devotional?.verses != null && devotional!.verses!.isNotEmpty) ...[
            _buildExpandableSection(
              context,
              theme,
              lang.relevantVerses,
              _isVersesExpanded,
              () {
                setState(() {
                  _isVersesExpanded = !_isVersesExpanded;
                });
              },
              _buildVersesContent(context, theme, devotional.verses!, lang),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
          ],
          if (devotional?.reflection != null &&
              devotional!.reflection!.isNotEmpty) ...[
            _buildExpandableSection(
              context,
              theme,
              lang.keyLearnings,
              _isReflectionExpanded,
              () {
                setState(() {
                  _isReflectionExpanded = !_isReflectionExpanded;
                });
              },
              Text(devotional.reflection!, style: theme.textTheme.bodyLarge),
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

  Widget _buildVersesContent(
    BuildContext context,
    ThemeData theme,
    List<DevotionalLogVerseRelationship> verses,
    S lang,
  ) {
    final auth = ref.read(authProvider);
    final userLang = auth.user?.lang?.name ?? 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: verses.map((verseRelationship) {
        final verse = verseRelationship.verse;
        if (verse == null ||
            verse.translations == null ||
            verse.translations!.isEmpty) {
          return const SizedBox.shrink();
        }

        final translation = verse.translations!.firstWhere(
          (t) => t.lang == userLang,
          orElse: () => verse.translations!.first,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (translation.text != null && translation.text!.isNotEmpty)
                Text(translation.text!, style: theme.textTheme.bodyLarge),
              if (translation.ref != null && translation.ref!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spacingXSmall),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    translation.ref!,
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
      }).toList(),
    );
  }
}
