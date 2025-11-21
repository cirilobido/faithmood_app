import 'package:flutter/material.dart';

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

    switch (type) {
      case AnalyticsPeriod.thisWeek:
        return 'This Week';
      case AnalyticsPeriod.lastWeek:
        return 'Last Week';
      case AnalyticsPeriod.thisMonth:
        return 'This Month';
      case AnalyticsPeriod.lastMonth:
        return 'Last Month';
    }
  }
}

