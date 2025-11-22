import 'package:flutter/material.dart';
import '../../../core/core_exports.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool centerTitle;
  final bool centerSubtitle;
  final Widget content;
  final double spacingAfterTitle;
  final double spacingAfterSubtitle;

  const SectionContainer({
    super.key,
    required this.title,
    this.subtitle,
    this.centerTitle = false,
    this.centerSubtitle = false,
    required this.content,
    this.spacingAfterTitle = AppSizes.spacingSmall,
    this.spacingAfterSubtitle = AppSizes.spacingXXLarge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineLarge,
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
          ),

          SizedBox(height: spacingAfterTitle),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: centerSubtitle
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: theme.textTheme.labelSmall?.color!,
                      ),
                      textAlign: centerSubtitle
                          ? TextAlign.center
                          : TextAlign.start,
                    ),

                  if (subtitle != null) SizedBox(height: spacingAfterSubtitle),

                  content,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
