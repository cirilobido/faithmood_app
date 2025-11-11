import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_exports.dart';
import '../../routes/app_routes_names.dart';
import '../../generated/l10n.dart';
import '../../widgets/widgets_exports.dart';
import '_welcome_view_model.dart';

class WelcomeView extends ConsumerStatefulWidget {
  const WelcomeView({super.key});

  @override
  ConsumerState<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends ConsumerState<WelcomeView> {
  final pageOneView = 0.0;
  final pageTwoView = 1.0;
  final pageThreeView = 2.0;
  double _pageControllerIndex = 0.0;
  final PageController _pageController = PageController(initialPage: 0);
  String? privacyUrl;
  String? termsUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final state = ref.watch(welcomeViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: _pageControllerIndex == pageOneView ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox.expand(
                  child: Image.asset(
                    AppIcons.welcomeWomanImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _pageControllerIndex == pageTwoView ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox.expand(
                  child: Image.asset(
                    AppIcons.welcomeManImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _pageControllerIndex == pageThreeView ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox.expand(
                  child: Image.asset(
                    AppIcons.welcomeWomanGreenImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppSizes.paddingMedium,
                    left: AppSizes.paddingMedium,
                    right: AppSizes.paddingMedium,
                  ),
                  child: SizedBox(
                    width: AppSizes.iconSizeSmall,
                    height: AppSizes.iconSizeSmall,
                    child: CircularProgressIndicator(
                      value: _pageControllerIndex.toDouble() / 2,
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppSizes.paddingMedium,
                    left: AppSizes.paddingMedium,
                    right: AppSizes.paddingMedium,
                  ),
                  child: (state.isLoading)
                      ? const SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            _handleNextPage(onSkipTap: true);
                          },
                          child: SizedBox(
                            height: AppSizes.iconSizeLarge,
                            child: Text(
                              lang.skip,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.spacingLarge),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _pageControllerIndex = index.toDouble();
                        });
                      },
                      children: [
                        _welcomeContent(),
                        _journalContent(),
                        _statsContent(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomButton(
                            isLoading: state.isLoading,
                            title: (_pageControllerIndex == pageOneView)
                                ? lang.getStarted
                                : lang.continueText,
                            type: (_pageControllerIndex == pageOneView)
                                ? ButtonType.primary
                                : ButtonType.secondary,
                            style: CustomStyle.filled,
                            onTap: () {
                              _handleNextPage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNextPage({bool onSkipTap = false}) async {
    if (_pageControllerIndex == pageThreeView || onSkipTap) {
      final viewModel = ref.read(welcomeViewModelProvider.notifier);
      if (onSkipTap) {
        viewModel.skipTapEvent();
      }
      await viewModel.setIsFirstTimeOpenFalse();
      context.go(Routes.signUp);
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Widget _title(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.displayLarge?.copyWith(
        color: AppColors.primary,
      ),
    );
  }

  Widget _subtitle(String subtitle) {
    final theme = Theme.of(context);
    final parts = subtitle.split('#');
    return RichText(
      text: TextSpan(
        style: theme.textTheme.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
        children: [
          TextSpan(text: parts.isNotEmpty ? parts[0] : ''),
          if (parts.length > 1)
            TextSpan(
              text: parts[1],
              style: theme.textTheme.headlineLarge?.copyWith(
                color: AppColors.secondary,
              ),
            ),
          if (parts.length > 2)
            TextSpan(text: parts[2]),
        ],
      ),
    );
  }

  Widget _welcomeContent() {
    final lang = S.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(lang.welcomeTitle1),
          const SizedBox(height: AppSizes.spacingSmall),
          _subtitle(lang.welcomeMessage1),
        ],
      ),
    );
  }

  Widget _journalContent() {
    final lang = S.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(lang.welcomeTitle2),
          const SizedBox(height: AppSizes.spacingSmall),
          _subtitle(lang.welcomeMessage2),
        ],
      ),
    );
  }

  Widget _statsContent() {
    final lang = S.of(context);
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(lang.welcomeTitle3),
          const SizedBox(height: AppSizes.spacingSmall),
          _subtitle(lang.welcomeMessage3),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
