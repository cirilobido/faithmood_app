import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const PageHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        InkWell(
          onTap: onBack ?? () => Navigator.of(context).pop(),
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
            title,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: AppSizes.iconSizeMedium),
      ],
    );
  }
}

