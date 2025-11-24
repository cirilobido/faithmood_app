import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../routes/app_routes_names.dart';
import '../../../widgets/widgets_exports.dart';
import '../../../features/journal/_journal_view_model.dart';
import '_add_mood_view_model.dart';
import 'widgets/_mood_page_switcher.dart';

class AddMoodView extends ConsumerStatefulWidget {
  final Mood? preSelectedMood;

  const AddMoodView({super.key, this.preSelectedMood});

  @override
  ConsumerState<AddMoodView> createState() => _AddMoodViewState();
}

class _AddMoodViewState extends ConsumerState<AddMoodView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.preSelectedMood != null) {
        ref.read(addMoodViewModelProvider.notifier).setPreSelectedMood(widget.preSelectedMood);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addMoodViewModelProvider);
    final vm = ref.read(addMoodViewModelProvider.notifier);
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
                vertical: AppSizes.paddingSmall,
              ),
              child: Row(
                children: [
                  if (state.currentPage > 0)
                    InkWell(
                      onTap: vm.previousPage,
                      splashColor: Colors.transparent,
                      overlayColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      child: SvgPicture.asset(
                        AppIcons.arrowLeftIcon,
                        width: AppSizes.iconSizeMedium,
                        colorFilter: ColorFilter.mode(
                          theme.primaryIconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  if (state.currentPage == 0)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => context.pop(),
                          splashColor: Colors.transparent,
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          child: SvgPicture.asset(
                            AppIcons.closeIcon,
                            width: AppSizes.iconSizeMedium,
                            colorFilter: ColorFilter.mode(
                              theme.primaryIconTheme.color!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: LoadingIndicator(
                        padding: EdgeInsets.all(AppSizes.paddingMedium),
                      ),
                    )
                  : state.error
                  ? ErrorState(
                      message: lang.unableToLoadMoods,
                      imagePath: AppIcons.sadPetImage,
                    )
                  : MoodPageSwitcher(
                      state: state,
                      onEmotionalMoodSelected: vm.selectEmotionalMood,
                      onSpiritualMoodSelected: vm.selectSpiritualMood,
                      onNoteChanged: vm.updateNote,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingMedium,
              ),
              child: CustomButton(
                title: state.currentPage < 2 ? lang.next : lang.addToMyJournal,
                type: ButtonType.primary,
                onTap: () async {
                  if (state.currentPage < 2) {
                    if (vm.canProceedToNextPage()) {
                      vm.nextPage();
                    } else {
                      CustomSnackBar.show(
                        context,
                        message: state.currentPage == 0
                            ? lang.pleaseSelectEmotionalMood
                            : lang.pleaseSelectSpiritualMood,
                        backgroundColor: theme.colorScheme.error,
                      );
                    }
                  } else {
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

                    final hasAddedMood = await ref.read(hasAddedMoodProvider.future);
                    final sessionId = await vm.saveMood();

                    if (context.mounted) {
                      context.pop();
                    }

                    if (sessionId != null && context.mounted) {
                      ref.read(journalViewModelProvider.notifier).refreshMoodSessionsIfNeeded();
                      
                      if (!hasAddedMood) {
                        _showSuccessModal(context, theme, lang, sessionId);
                      } else {
                        context.pushWithAd(
                          ref,
                          Routes.moodEntryDetails,
                          extra: {'sessionId': sessionId},
                          forceShow: true,
                          popBeforePush: true,
                        );
                      }
                    } else if (context.mounted) {
                      CustomSnackBar.show(
                        context,
                        message: lang.errorSavingMood,
                        backgroundColor: theme.colorScheme.error,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessModal(BuildContext context, ThemeData theme, S lang, String sessionId) {
    CustomDialogModal.show(
      context: context,
      title: lang.moodAddedSuccessfully,
      content: lang.moodAddedSuccessfullyMessage,
      buttonTitle: lang.goToJournal,
      iconPath: AppIcons.happyPetImage,
      onPrimaryTap: () async {
        context.pop();
        context.pushWithAd(
          ref,
          Routes.moodEntryDetails,
          extra: {'sessionId': sessionId},
          forceShow: true,
        );
      },
    );
  }
}
