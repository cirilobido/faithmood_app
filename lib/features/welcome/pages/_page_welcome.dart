import 'package:flutter/material.dart' hide AnimatedContainer;
import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/widgets_exports.dart';
import '../widgets/_section_container.dart';

class PageWelcome extends StatelessWidget {
  const PageWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SectionContainer(
      title: lang.welcomeTitle,
      subtitle: lang.welcomeSubtitle,
      centerTitle: true,
      centerSubtitle: true,
      content: AnimatedContainer(
        mode: AnimationMode.floating,
        duration: const Duration(seconds: 4),
        floatRange: 10,
        child: Image.asset(AppIcons.welcomePetImage, width: screenWidth * 0.8),
      ),
    );
  }
}