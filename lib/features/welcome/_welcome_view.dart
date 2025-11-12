import 'package:flutter/material.dart' hide AnimatedContainer;
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

    final lang = S.of(context);
    final state = ref.watch(welcomeViewModelProvider);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingLarge,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSizes.spacingXXLarge),
                  child: Center(
                    child:
                    AnimatedContainer(
                      mode: AnimationMode.pulse,
                      child: Image.asset(
                        AppIcons.greenGradientImage,
                        fit: BoxFit.fitWidth,
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
                      children: [_welcomeContent()],
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
      style: theme.textTheme.headlineLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _subtitle(String subtitle) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Text(
      subtitle,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.dTextSecondary : AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _welcomeContent() {
    final lang = S.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _title('Welcome to your new space of faith'),
          const SizedBox(height: AppSizes.spacingMedium),
          _subtitle('A place to connect with yourself and with God every day.'),
          const SizedBox(height: AppSizes.spacingMedium),
          AnimatedContainer(
            mode: AnimationMode.floating,
            duration: const Duration(seconds: 4),
            floatRange: 10,
            child: Image.asset(
              AppIcons.welcomePetImage,
              width: screenWidth * 0.8,
            ),
          ),
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
