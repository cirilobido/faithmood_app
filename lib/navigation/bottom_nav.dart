import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../core/core_exports.dart';
import '../generated/l10n.dart';
import '../routes/app_routes_names.dart';

class BottomNavScreen extends StatefulWidget {
  final Widget child;

  const BottomNavScreen({super.key, required this.child});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  static const List<String> _routes = [
    Routes.home,
    Routes.devotional,
    Routes.mood,
    Routes.journal,
    Routes.profile,
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Plus icon - handle differently if needed
      return;
    }
    if (_selectedIndex != index) {
      context.go(_routes[index]);
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _getCurrentIndex(BuildContext context) {
    final routerDelegate = GoRouter.of(context).routerDelegate;
    String location = routerDelegate.currentConfiguration.uri.toString();
    if (location.startsWith(Routes.home)) {
      _selectedIndex = 0;
    } else if (location.startsWith(Routes.devotional)) {
      _selectedIndex = 1;
    } else if (location.startsWith(Routes.journal)) {
      _selectedIndex = 3; // Journal is at index 3
    } else if (location.startsWith(Routes.profile)) {
      _selectedIndex = 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    _getCurrentIndex(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(child: widget.child),
      bottomNavigationBar: Container(
        // height: AppSizes.bottomNavHeight,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: AppSizes.borderWithSmall,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: AppIcons.homeIcon,
              label: lang.home,
              isSelected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            _buildNavItem(
              context: context,
              icon: AppIcons.openBookIcon,
              label: 'Plans',
              isSelected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            _buildPlusButton(context: context),
            _buildNavItem(
              context: context,
              icon: AppIcons.journalIcon,
              label: 'Journal',
              isSelected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            _buildNavItem(
              context: context,
              icon: AppIcons.profileIcon,
              label: lang.profile,
              isSelected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.textTheme.bodyLarge?.color;
    final textColor = isSelected
        ? theme.colorScheme.primary
        : theme.textTheme.bodyLarge?.color;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.bottomNavSelectorWidth,
              height: AppSizes.bottomNavSelectorHeight,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
              width: AppSizes.iconSizeLarge,
              height: AppSizes.iconSizeLarge,
            ),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildPlusButton({required BuildContext context}) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppSizes.iconSizeXXLarge,
          height: AppSizes.iconSizeXXLarge,
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingSmall),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          child: SvgPicture.asset(
            AppIcons.addIcon,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
            width: AppSizes.iconSizeXXLarge,
            height: AppSizes.iconSizeXXLarge,
          ),
        ),
        const SizedBox(height: AppSizes.spacingMedium),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
