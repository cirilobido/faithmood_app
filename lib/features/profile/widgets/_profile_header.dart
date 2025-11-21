import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes/app_routes_names.dart';

class ProfileHeader extends StatelessWidget {
  final User? user;
  final bool isPremium;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? lang.user,
                style: theme.textTheme.headlineMedium,
              ),
              if (isPremium) _PremiumBadge(),
            ],
          ),
        ),
        _SettingsButton(),
      ],
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        lang.premium,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.background,
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => context.push(Routes.settings),
      child: SvgPicture.asset(
        AppIcons.settingsIcon,
        height: AppSizes.iconSizeLarge,
        width: AppSizes.iconSizeLarge,
        colorFilter: ColorFilter.mode(
          theme.primaryIconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

