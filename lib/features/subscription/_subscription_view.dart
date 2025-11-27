import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:purchases_ui_flutter/views/paywall_view.dart';

import '../../core/core_exports.dart';
import '../../routes/app_routes_names.dart';
import '_subscription_view_model.dart';

class SubscriptionView extends ConsumerStatefulWidget {
  final PaywallEnum paywall;

  const SubscriptionView({super.key, required this.paywall});

  @override
  ConsumerState<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends ConsumerState<SubscriptionView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .loadPaywall(
            offeringId: widget.paywall.paywallId,
            onCompleted: () => _onPaywallFinished(),
          );
    });
  }

  void _onPaywallFinished() {
    if (widget.paywall == PaywallEnum.welcome) {
      context.go(Routes.home);
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(subscriptionViewModelProvider.notifier);
    final state = ref.watch(subscriptionViewModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: (state.isLoading || state.offering == null)
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.spacingLarge),
                    child: AnimatedOpacity(
                      opacity: state.isLoading ? 1 : 0,
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOut,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            _onPaywallFinished.call();
                          },
                          child: SvgPicture.asset(
                            AppIcons.closeIcon,
                            height: AppSizes.iconSizeMedium,
                            width: AppSizes.iconSizeMedium,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).iconTheme.color ?? AppColors.dIconPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              )
            : Center(
                child: PaywallView(
                  offering: state.offering!,
                  onPurchaseStarted: viewModel.onPurchaseStarted,
                  onPurchaseCompleted: viewModel.onPurchaseCompleted,
                  onPurchaseError: viewModel.onPurchaseError,
                  onRestoreCompleted: viewModel.onRestoreCompleted,
                  onRestoreError: viewModel.onRestoreError,
                  onDismiss: _onPaywallFinished,
                ),
              ),
      ),
    );
  }
}

