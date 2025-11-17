import 'package:flutter/material.dart';

import '../pages/_page_welcome.dart';
import '../pages/_page_profile.dart';
import '../pages/_page_experience.dart';
import '../pages/_page_committed.dart';
import '../pages/_page_ever_used.dart';
import '../pages/_page_join_other.dart';
import '../pages/_page_guided_plan.dart';
import '../pages/_page_notifications.dart';
import '../pages/_page_preparing.dart';
import '../pages/_page_paywall.dart';
import '../pages/_page_social.dart';
import '../pages/_page_rating.dart';

class WelcomePageSwitcher extends StatelessWidget {
  final int index;

  WelcomePageSwitcher({super.key, required this.index});

  final pages = <int, Widget Function(Key)>{
    0: (key) => PageWelcome(key: key),
    1: (key) => PageProfile(key: key),
    2: (key) => PageExperience(key: key),
    3: (key) => PageCommitted(key: key),
    4: (key) => PageEverUsed(key: key),
    5: (key) => PageJoinOther(key: key),
    6: (key) => PageGuidedPlan(key: key),
    7: (key) => PageNotifications(key: key),
    8: (key) => PagePreparing(key: key),
    9: (key) => PagePaywall(key: key),
    10: (key) => PageSocial(key: key),
    11: (key) => PageRating(key: key)
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeInOut,
      child: _buildPage(index),
    );
  }

  Widget _buildPage(int i) {
    final builder = pages[i];
    if (builder != null) {
      return builder(ValueKey(i));
    }
    return const SizedBox();
  }
}
