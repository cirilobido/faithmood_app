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
    Routes.journal,
    Routes.profile,
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      context.go(_routes[index]);
      setState(() {
        _selectedIndex = index;
      });
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _getCurrentIndex(BuildContext context) {
    final routerDelegate = GoRouter.of(context).routerDelegate;
    String location = routerDelegate.currentConfiguration.uri.toString();
    if (location.startsWith(Routes.home)) {
      _selectedIndex = 0;
    } else if (location.startsWith(Routes.devotional)) {
      _selectedIndex = 1;
    } else if (location.startsWith(Routes.journal)) {
      _selectedIndex = 2;
    } else if (location.startsWith(Routes.profile)) {
      _selectedIndex = 3;
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
        height: AppSizes.bottomNavHeight,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.bottomNavDivider, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(context: context, iconPath: AppIcons.homeIcon),
              activeIcon: _buildIcon(
                context: context,
                iconPath: AppIcons.homeIcon,
                isSelected: true,
              ),
              label: lang.home,
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(context: context, iconPath: AppIcons.homeIcon),
              activeIcon: _buildIcon(
                context: context,
                iconPath: AppIcons.homeIcon,
                isSelected: true,
              ),
              label: lang.campains,
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(context: context, iconPath: AppIcons.userIcon),
              activeIcon: _buildIcon(
                context: context,
                iconPath: AppIcons.userIcon,
                isSelected: true,
              ),
              label: lang.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon({
    required BuildContext context,
    required String iconPath,
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);
    return SvgPicture.asset(
      iconPath,
      height: AppSizes.iconSizeRegular,
      width: AppSizes.iconSizeRegular,
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.primary : theme.iconTheme.color!,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
