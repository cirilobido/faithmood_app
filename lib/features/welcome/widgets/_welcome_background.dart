import 'package:flutter/material.dart';

import '../../../core/core_exports.dart';

class WelcomeBackground extends StatelessWidget {
  final int index;
  final bool isDark;

  const WelcomeBackground({
    super.key,
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 450),
      child: IgnorePointer(
        ignoring: true,
        child: Align(
          alignment: _backgroundAlignment(index),
          child: Image.asset(
            AppIcons.greenGradientOvalImage,
            height: 420,
            width: 420,
            opacity: AlwaysStoppedAnimation(isDark ? .3 : 1),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Alignment _backgroundAlignment(int page) {
    const map = {
      0: Alignment.center,
      1: Alignment.bottomRight,
      2: Alignment.bottomLeft,
      3: Alignment.center,
      4: Alignment.bottomCenter,
      5: Alignment.bottomCenter,
      6: Alignment.centerLeft,
      7: Alignment.bottomCenter,
      8: Alignment.bottomCenter,
      9: Alignment.bottomCenter,
      10: Alignment.bottomCenter,
      11: Alignment.center,
    };
    return map[page] ?? Alignment.center;
  }
}
