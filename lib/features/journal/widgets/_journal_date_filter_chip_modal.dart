import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/widgets_exports.dart';
import '../_journal_view_model.dart';

class JournalDateFilterChipModal extends ConsumerStatefulWidget {
  const JournalDateFilterChipModal({super.key});

  @override
  ConsumerState<JournalDateFilterChipModal> createState() =>
      _JournalDateFilterChipModalState();
}

class _JournalDateFilterChipModalState
    extends ConsumerState<JournalDateFilterChipModal> {
  DateTime? _startDate;
  DateTime? _endDate;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    final journalState = ref.read(journalViewModelProvider);
    _startDate = journalState.startDate;
    _endDate = journalState.endDate;
    _startDateController = TextEditingController(
      text: _startDate != null ? _formatDate(_startDate) : '',
    );
    _endDateController = TextEditingController(
      text: _endDate != null ? _formatDate(_endDate) : '',
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy', 'en').format(date);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text = _formatDate(_startDate);
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
          _endDateController.text = '';
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateController.text = _formatDate(_endDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final journalVm = ref.read(journalViewModelProvider.notifier);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.dateRange, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSizes.spacingLarge),

            InputField(
              label: lang.startDate,
              hintText: lang.startDate,
              controller: _startDateController,
              fieldType: FieldType.date,
              readOnly: true,
              suffixIconWidget: SvgPicture.asset(
                AppIcons.calendarIcon,
                width: AppSizes.iconSizeNormal,
                height: AppSizes.iconSizeNormal,
                colorFilter: ColorFilter.mode(
                  theme.iconTheme.color!.withValues(alpha: 0.8),
                  BlendMode.srcIn,
                ),
              ),
              onTap: () => _selectStartDate(context),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            InputField(
              label: lang.endDate,
              hintText: lang.endDate,
              controller: _endDateController,
              fieldType: FieldType.date,
              readOnly: true,
              suffixIconWidget: SvgPicture.asset(
                AppIcons.calendarIcon,
                width: AppSizes.iconSizeNormal,
                height: AppSizes.iconSizeNormal,
                colorFilter: ColorFilter.mode(
                  theme.iconTheme.color!.withValues(alpha: 0.8),
                  BlendMode.srcIn,
                ),
              ),
              onTap: () => _selectEndDate(context),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            CustomButton(
              title: lang.applyFilters,
              type: ButtonType.neutral,
              isShortText: true,
              onTap: () {
                journalVm.filterByDateRange(_startDate, _endDate);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            CustomButton(
              title: lang.clearFilters,
              type: ButtonType.neutral,
              style: CustomStyle.outlined,
              isShortText: true,
              onTap: () {
                if (_startDate != null || _endDate != null) {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                    _startDateController.text = '';
                    _endDateController.text = '';
                  });
                  journalVm.clearDateFilters();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
