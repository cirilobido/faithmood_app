import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../../../features/journal/_journal_view_model.dart';
import '_devotional_details_view_model.dart';
import '_devotional_details_state.dart';
import '../../../widgets/tts_player_dialog/_tts_player_dialog.dart';

class DevotionalDetailsView extends ConsumerStatefulWidget {
  final int devotionalId;

  const DevotionalDetailsView({super.key, required this.devotionalId});

  @override
  ConsumerState<DevotionalDetailsView> createState() =>
      _DevotionalDetailsViewState();
}

class _DevotionalDetailsViewState extends ConsumerState<DevotionalDetailsView> {
  final TextEditingController _reflectionController = TextEditingController();
  bool _isVersesExpanded = true;
  bool _isLearningsExpanded = false;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      devotionalDetailsViewModelProvider(widget.devotionalId),
    );
    final vm = ref.read(
      devotionalDetailsViewModelProvider(widget.devotionalId).notifier,
    );
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            DetailsPageHeader(
              title: lang.devotional,
              onBack: () async {
                await vm.stopTTS();
                if (state.hasUnsavedChanges && !state.isSaved) {
                  final note = await SaveNoteModal.show(
                    context: context,
                    initialNote: state.reflectionText,
                  );

                  if (note != null) {
                    final success = await vm.saveReflection(note: note);
                    if (success && context.mounted) {
                      ref
                          .read(journalViewModelProvider.notifier)
                          .refreshDevotionalLogsIfNeeded();
                      CustomSnackBar.show(
                        context,
                        message: S.of(context).noteSavedSuccessfully,
                      );
                      if (context.mounted) {
                        context.pop();
                      }
                    } else if (context.mounted) {
                      CustomSnackBar.show(
                        context,
                        message: S.of(context).errorSavingNote,
                        backgroundColor: theme.colorScheme.error,
                      );
                    }
                  } else {
                    final success = await vm.saveNoteWithoutReflection();
                    if (success) {
                      ref
                          .read(journalViewModelProvider.notifier)
                          .refreshDevotionalLogsIfNeeded();
                    }
                    context.pop();
                  }
                } else {
                  context.pop();
                }
              },
              action: DevotionalOptionsHeaderAction(
                isFavorite: state.isFavorite,
                isPlaying: state.isPlaying,
                isPaused: state.isPaused,
                onToggleFavorite: () => vm.toggleFavorite(),
                onTtsTap: () async {
                  if (state.isPlaying) {
                    await vm.pauseTTS();
                  } else if (state.isPaused) {
                    await vm.playTTS();
                  } else {
                    await vm.playTTS();
                  }
                  if (context.mounted) {
                    TtsPlayerDialog.show(
                      context: context,
                      devotionalId: widget.devotionalId,
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
                      message: lang.unableToLoadDevotionals,
                      imagePath: AppIcons.sadPetImage,
                    )
                  : state.devotional == null
                  ? EmptyState(message: lang.noDevotionalsAvailable)
                  : _buildContent(context, theme, state, vm, lang),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    DevotionalDetailsState state,
    DevotionalDetailsViewModel vm,
    S lang,
  ) {
    final devotional = state.devotional!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (devotional.coverImage != null &&
              devotional.coverImage!.isNotEmpty) ...[
            CategoryTagImage(imageUrl: devotional.coverImage!),
            const SizedBox(height: AppSizes.spacingMedium),
          ],
          if (devotional.verses != null && devotional.verses!.isNotEmpty) ...[
            VerseContent(verses: devotional.verses!),
          ],
          const SizedBox(height: AppSizes.spacingLarge),
          Text(devotional.title ?? '', style: theme.textTheme.headlineMedium),
          if (devotional.tags != null && devotional.tags!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingSmall),
            Wrap(
              spacing: AppSizes.spacingSmall,
              runSpacing: AppSizes.spacingSmall,
              children: devotional.tags!.map((tag) {
                return DevotionalTagChip(tag: tag, isClickable: false);
              }).toList(),
            ),
          ],
          if (devotional.content != null && devotional.content!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            Text(devotional.content!, style: theme.textTheme.bodyLarge),
          ],
          const SizedBox(height: AppSizes.spacingMedium),
          NativeAdmobAd(isBigBanner: true),
          const SizedBox(height: AppSizes.spacingMedium),
          if (devotional.reflection != null &&
              devotional.reflection!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            ExpandableSection(
              title: lang.keyLearnings,
              isExpanded: _isLearningsExpanded,
              onToggle: () {
                setState(() {
                  _isLearningsExpanded = !_isLearningsExpanded;
                });
              },
              content: Text(
                devotional.reflection!,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
          const SizedBox(height: AppSizes.spacingLarge),
          Text(lang.myReflection, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSizes.spacingSmall),
          InputField(
            hintText: lang.whatsOnYourHeartToday,
            textInputAction: TextInputAction.newline,
            isMultiline: true,
            initialValue: state.reflectionText,
            onChanged: (value) => vm.updateReflectionText(value),
          ),
          const SizedBox(height: AppSizes.spacingLarge),
          CustomButton(
            title: lang.saveNotes,
            type: ButtonType.primary,
            isLoading: state.isSaving,
            onTap: () async {
              final success = await vm.saveReflection();
              if (success && context.mounted) {
                ref
                    .read(journalViewModelProvider.notifier)
                    .refreshDevotionalLogsIfNeeded();
                CustomSnackBar.show(
                  context,
                  message: lang.noteSavedSuccessfully,
                  backgroundColor: theme.colorScheme.primary,
                );
                if (context.mounted) {
                  context.pop();
                }
              } else if (context.mounted) {
                CustomSnackBar.show(
                  context,
                  message: lang.errorSavingNote,
                  backgroundColor: theme.colorScheme.error,
                );
              }
            },
          ),
          const SizedBox(height: AppSizes.spacingLarge),
        ],
      ),
    );
  }
}
