import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

enum AnalyticsPeriod {
  thisWeek('this_week'),
  lastWeek('last_week'),
  thisMonth('this_month'),
  lastMonth('last_month');

  final String? key;

  const AnalyticsPeriod(this.key);

  static String? toTitle({
    required BuildContext context,
    required AnalyticsPeriod? type,
  }) {
    if (type == null) return null;

    final lang = S.of(context);

    switch (type) {
      case AnalyticsPeriod.thisWeek:
        return lang.thisWeek;
      case AnalyticsPeriod.lastWeek:
        return lang.lastWeek;
      case AnalyticsPeriod.thisMonth:
        return lang.thisMonth;
      case AnalyticsPeriod.lastMonth:
        return lang.lastMonth;
    }
  }
}

