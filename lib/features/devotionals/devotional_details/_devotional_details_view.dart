import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '_devotional_details_view_model.dart';
import '_devotional_details_state.dart';

class DevotionalDetailsView extends ConsumerStatefulWidget {
  final int devotionalId;

  const DevotionalDetailsView({super.key, required this.devotionalId});

  @override
  ConsumerState<DevotionalDetailsView> createState() =>
      _DevotionalDetailsViewState();
}

class _DevotionalDetailsViewState extends ConsumerState<DevotionalDetailsView> {
  final TextEditingController _reflectionController = TextEditingController();
  bool _isVersesExpanded = false;
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
              title: S.of(context).devotional,
              onBack: () async {
                if (state.hasUnsavedChanges && !state.isSaved) {
                  final note = await SaveNoteModal.show(
                    context: context,
                    initialNote: state.reflectionText,
                  );

                  if (note != null) {
                    final success = await vm.saveReflection(note: note);
                    if (success && context.mounted) {
                      CustomSnackBar.show(
                        context,
                        message: S.of(context).noteSavedSuccessfully,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } else if (context.mounted) {
                      CustomSnackBar.show(
                        context,
                        message: S.of(context).errorSavingNote,
                        backgroundColor: theme.colorScheme.error,
                      );
                    }
                  } else {
                    await vm.saveNoteWithoutReflection();
                    Navigator.of(context).pop();
                  }
                } else {
                  Navigator.of(context).pop();
                }
              },
              action: FavoriteHeaderAction(
                isFavorite: state.isFavorite,
                onToggle: () => vm.toggleFavorite(),
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
          Text(devotional.title ?? '', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSizes.spacingMedium),
          if (devotional.content != null && devotional.content!.isNotEmpty)
            Text(devotional.content!, style: theme.textTheme.bodyLarge),
          if (devotional.tags != null && devotional.tags!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingLarge),
            Text(lang.tags, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSizes.spacingSmall),
            Wrap(
              spacing: AppSizes.spacingSmall,
              runSpacing: AppSizes.spacingSmall,
              children: devotional.tags!.map((tag) {
                return DevotionalTagChip(tag: tag, isClickable: false);
              }).toList(),
            ),
          ],
          if (devotional.verses != null && devotional.verses!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingLarge),
            ExpandableSection(
              title: lang.relevantVerses,
              isExpanded: _isVersesExpanded,
              onToggle: () {
                setState(() {
                  _isVersesExpanded = !_isVersesExpanded;
                });
              },
              content: VerseContent(verses: devotional.verses!),
            ),
          ],
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
                CustomSnackBar.show(
                  context,
                  message: lang.noteSavedSuccessfully,
                  backgroundColor: theme.colorScheme.primary,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
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
