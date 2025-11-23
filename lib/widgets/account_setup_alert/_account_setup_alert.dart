import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../../routes/app_routes_names.dart';

class AccountSetupAlert extends StatefulWidget {
  const AccountSetupAlert({super.key});

  @override
  State<AccountSetupAlert> createState() => _AccountSetupAlertState();
}

class _AccountSetupAlertState extends State<AccountSetupAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return InkWell(
      onTap: () {
        context.push(Routes.signUp);
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withValues(alpha: 0.1),
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.4),
            width: AppSizes.borderWithSmall,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.paddingXSmall),
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: AppSizes.iconSizeXSmall,
                      height: AppSizes.iconSizeXSmall,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSizes.spacingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.finishAccountSetup,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Text(
                    lang.finishAccountSetupMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.labelSmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

