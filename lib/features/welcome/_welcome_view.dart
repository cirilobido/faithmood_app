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
              SizedBox.expand(
                child: Center(
                  child: Image.asset(
                    AppIcons.greenGradientImage,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox.expand(
                child: Image.asset(
                  AppIcons.welcomePetImage,
                  fit: BoxFit.cover,
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
                            title: lang.getStarted,
                            type: ButtonType.primary,
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

  void _handleNextPage() async {
      final viewModel = ref.read(welcomeViewModelProvider.notifier);
      await viewModel.setIsFirstTimeOpenFalse();
      context.go(Routes.signUp);

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
