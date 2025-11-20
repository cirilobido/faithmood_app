import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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
            _buildHeader(context, theme, state, vm),
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

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    DevotionalDetailsState state,
    DevotionalDetailsViewModel vm,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingMedium,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
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
              S.of(context).devotional,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: () => vm.toggleFavorite(),
            splashColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: SvgPicture.asset(
              state.isFavorite
                  ? AppIcons.bookmarkFilledIcon
                  : AppIcons.bookmarkIcon,
              width: AppSizes.iconSizeMedium,
              colorFilter: ColorFilter.mode(
                state.isFavorite
                    ? theme.colorScheme.primary
                    : theme.primaryIconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
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
              _buildVersesContent(context, theme, devotional.verses!),
            ),
          ],
          if (devotional.reflection != null &&
              devotional.reflection!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingMedium),
            _buildExpandableSection(
              context,
              theme,
              lang.keyLearnings,
              _isLearningsExpanded,
              () {
                setState(() {
                  _isLearningsExpanded = !_isLearningsExpanded;
                });
              },
              Text(
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
                  backgroundColor: AppColors.primary,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } else if (context.mounted) {
                CustomSnackBar.show(
                  context,
                  message: lang.errorSavingNote,
                  backgroundColor: AppColors.error,
                );
              }
            },
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
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
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
    List<DevotionalVerse> verses,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: verses.map((verse) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(verse.text ?? '', style: theme.textTheme.bodyLarge),
              if (verse.ref != null && verse.ref!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spacingXSmall),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    verse.ref!,
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
