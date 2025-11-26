import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../core/core_exports.dart';
import '../generated/l10n.dart';
import '../routes/app_routes_names.dart';
import '../widgets/widgets_exports.dart' hide AnimatedContainer;

class BottomNavScreen extends ConsumerStatefulWidget {
  final Widget child;

  const BottomNavScreen({super.key, required this.child});

  @override
  ConsumerState<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  int _selectedIndex = 0;
  bool _isMoving = false;
  static const List<String> _routes = [
    Routes.home,
    Routes.devotional,
    Routes.addMood,
    Routes.journal,
    Routes.profile,
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      context.push(_routes[index]);
      return;
    }
    if (_selectedIndex != index) {
      context.go(_routes[index]);
      setState(() {
        _selectedIndex = index;
        _isMoving = true;
      });
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            _isMoving = false;
          });
        }
      });
    }
  }

  void _getCurrentIndex(BuildContext context) {
    final routerDelegate = GoRouter.of(context).routerDelegate;
    String location = routerDelegate.currentConfiguration.uri.toString();
    int newIndex = _selectedIndex;
    
    if (location.startsWith(Routes.home)) {
      newIndex = 0;
    } else if (location.startsWith(Routes.devotional)) {
      newIndex = 1;
    } else if (location.startsWith(Routes.journal)) {
      newIndex = 3; // Journal is at index 3
    } else if (location.startsWith(Routes.profile)) {
      newIndex = 4;
    }
    
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
        _isMoving = true;
      });
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            _isMoving = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    _getCurrentIndex(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: widget.child),
            Consumer(
              builder: (context, ref, child) {
                final auth = ref.watch(authProvider);
                final settings = ref.watch(settingsProvider);
                final isPremium = auth.user?.planType != PlanName.FREE;
                final showBannerAds = settings.isBannerAdEnable;
                if (isPremium || !showBannerAds) return const SizedBox.shrink();
                return NativeAdmobAd(isNativeBanner: false);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: AppSizes.borderWithSmall,
            ),
          ),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: AppIcons.homeIcon,
                  label: lang.home,
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                  index: 0,
                ),
                _buildNavItem(
                  context: context,
                  icon: AppIcons.openBookIcon,
                  label: lang.faith,
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                  index: 1,
                ),
                _buildPlusButton(context: context),
                _buildNavItem(
                  context: context,
                  icon: AppIcons.journalIcon,
                  label: lang.journal,
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),
                  index: 3,
                ),
                _buildNavItem(
                  context: context,
                  icon: AppIcons.profileIcon,
                  label: lang.profile,
                  isSelected: _selectedIndex == 4,
                  onTap: () => _onItemTapped(4),
                  index: 4,
                ),
              ],
            ),
            _buildAnimatedIndicator(context: context),
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
    required int index,
  }) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.textTheme.labelSmall?.color ?? Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSizes.bottomNavSelectorHeight),
            const SizedBox(height: AppSizes.spacingSmall),
            TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              tween: ColorTween(
                begin: isSelected ? unselectedColor : selectedColor,
                end: isSelected ? selectedColor : unselectedColor,
              ),
              builder: (context, color, child) {
                return SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(color ?? unselectedColor, BlendMode.srcIn),
                  width: AppSizes.iconSizeLarge,
                  height: AppSizes.iconSizeLarge,
                );
              },
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: FontWeight.w700,
              ) ?? const TextStyle(),
              child: Text(label),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIndicator({required BuildContext context}) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5;
    
    double leftPosition;
    if (_selectedIndex == 0) {
      leftPosition = itemWidth / 2 - AppSizes.bottomNavSelectorWidth / 2;
    } else if (_selectedIndex == 1) {
      leftPosition = itemWidth * 1.5 - AppSizes.bottomNavSelectorWidth / 2;
    } else if (_selectedIndex == 3) {
      leftPosition = itemWidth * 3.5 - AppSizes.bottomNavSelectorWidth / 2;
    } else if (_selectedIndex == 4) {
      leftPosition = itemWidth * 4.5 - AppSizes.bottomNavSelectorWidth / 2;
    } else {
      leftPosition = 0;
    }

    final indicatorSize = _isMoving 
        ? AppSizes.bottomNavSelectorHeight 
        : AppSizes.bottomNavSelectorWidth;
    final borderRadius = _isMoving 
        ? BorderRadius.circular(AppSizes.bottomNavSelectorHeight / 2)
        : BorderRadius.circular(AppSizes.radiusSmall);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      left: _isMoving 
          ? leftPosition + (AppSizes.bottomNavSelectorWidth - AppSizes.bottomNavSelectorHeight) / 2
          : leftPosition,
      top: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: indicatorSize,
        height: AppSizes.bottomNavSelectorHeight,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget _buildPlusButton({required BuildContext context}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _onItemTapped(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.iconSizeXXLarge,
            height: AppSizes.iconSizeXXLarge,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingSmall,
            ),
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
