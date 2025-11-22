import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '_reminder_view_model.dart';

class ReminderView extends ConsumerStatefulWidget {
  const ReminderView({super.key});

  @override
  ConsumerState<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends ConsumerState<ReminderView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(reminderViewModelProvider.notifier);
      viewModel.loadData();
    });
  }

  Future<void> _pickTime() async {
    final state = ref.read(reminderViewModelProvider);
    TimeOfDay? reminderTime = DateHelper.parseTimeOfDay(state.time ?? '');
    final now = TimeOfDay.now();
    final theme = Theme.of(context);

    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTime ?? now,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onSurface: theme.colorScheme.onSurface,
              surface: theme.colorScheme.surface,
              secondary: theme.colorScheme.secondary,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: theme.colorScheme.onSurface,

              hourMinuteColor: theme.colorScheme.secondary.withValues(alpha: 0.4),
              hourMinuteTextStyle: theme.textTheme.headlineLarge,
              hourMinuteTextColor: theme.textTheme.bodyLarge?.color,

              dialBackgroundColor: theme.colorScheme.secondary.withValues(
                alpha: 0.4,
              ),
              dialHandColor: theme.colorScheme.primary,
              dialTextColor: theme.textTheme.bodyLarge?.color,
              dialTextStyle: theme.textTheme.bodyLarge,

              dayPeriodColor: theme.colorScheme.onSurface,
              dayPeriodTextColor: theme.textTheme.bodyMedium?.color,
              dayPeriodTextStyle: theme.textTheme.bodyMedium,
              
              entryModeIconColor: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final viewModel = ref.read(reminderViewModelProvider.notifier);
      await viewModel.updateTime(picked);

      final lang = S.of(context);

      await LocalNotificationsService.instance().scheduleDailyNotification(
        hour: picked.hour,
        minute: picked.minute,
        title: lang.reminderNotificationTitle,
        body: lang.reminderNotificationMessage,
      );

      CustomSnackBar.show(context, message: lang.yourDailyReminderIsSet);
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = S.of(context);
    final viewModel = ref.read(reminderViewModelProvider.notifier);
    final state = ref.watch(reminderViewModelProvider);
    final hasReminder = state.time != null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        lang.reminder,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingSmall),
                Text(lang.reminderMessage, style: theme.textTheme.bodyLarge),
                if (state.isLoading)
                  Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                if (!state.isLoading)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: AppSizes.spacingLarge),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  AppIcons.greenFigureIcon,
                                  height: AppSizes.dialogIconSize,
                                  colorFilter: ColorFilter.mode(
                                    theme.colorScheme.secondary.withValues(
                                      alpha: isDark ? 0.4 : 1,
                                    ),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  AppIcons.bellBlueIcon,
                                  height: AppSizes.premiumIconSize,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.spacingLarge),
                          Text(
                            lang.dailyDreamReminder,
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.spacingMedium),
                          if (hasReminder) ...[
                            Text(
                              state.time ?? '',
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: AppSizes.spacingMedium),
                            Text(
                              lang.reminderSetMessage,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSizes.spacingXLarge),
                            CustomButton(
                              title: lang.changeTime,
                              type: ButtonType.secondary,
                              style: CustomStyle.filled,
                              onTap: _pickTime,
                            ),
                            const SizedBox(height: AppSizes.spacingMedium),
                            CustomButton(
                              title: lang.removeReminder,
                              type: ButtonType.neutral,
                              style: CustomStyle.outlined,
                              onTap: () async {
                                await viewModel.deleteReminderTime();
                                await LocalNotificationsService.instance()
                                    .cancelDailyNotification();
                                CustomSnackBar.show(
                                  context,
                                  backgroundColor: theme.colorScheme.error,
                                  message: lang.reminderDeleted,
                                );
                              },
                            ),
                          ] else ...[
                            Text(
                              lang.reminderNoSetMessage,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.textTheme.labelSmall?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSizes.spacingMedium),
                            CustomButton(
                              title: lang.setReminder,
                              type: ButtonType.primary,
                              style: CustomStyle.filled,
                              onTap: _pickTime,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSizes.spacingLarge),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    AppIcons.arrowLeftIcon,
                    height: AppSizes.iconSizeXLarge,
                    width: AppSizes.iconSizeXLarge,
                    colorFilter: ColorFilter.mode(
                      theme.primaryIconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

