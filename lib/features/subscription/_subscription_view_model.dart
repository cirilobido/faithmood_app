import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../dev_utils/_logger.dart';
import '../../core/core_exports.dart';
import '_subscription_state.dart';

final subscriptionViewModelProvider =
    StateNotifierProvider<SubscriptionViewModel, SubscriptionState>(
      (ref) => SubscriptionViewModel(
        ref.read(firebaseAnalyticProvider),
        ref.read(authProvider),
      ),
    );

class SubscriptionViewModel extends StateNotifier<SubscriptionState> {
  final FirebaseAnalyticProvider analytic;
  final AuthProvider _authProvider;

  SubscriptionViewModel(this.analytic, this._authProvider)
    : super(SubscriptionState());

  String? _offeringId;
  void Function()? _onPaywallCompleted;

  Future<void> loadPaywall({
    String offeringId = 'default',
    required void Function() onCompleted,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      _offeringId = offeringId;
      _onPaywallCompleted = onCompleted;

      final offerings = await Purchases.getOfferings();

      final offering = offerings.all[_offeringId];

      if (offering != null) {
        final user = _authProvider.user;

        if (user?.id != null) {
          await Purchases.logIn(user!.id.toString());

          await Purchases.setAttributes({
            if (user.name != null) 'name': user.name!,
            if (user.name != null) 'displayName': user.name!,
          });
        }

        state = state.copyWith(
          isLoading: false,
          offering: offering,
          errorMessage: null,
        );

        analytic.logEvent(
          name: 'paywall_presented',
          parameters: {
            'screen': 'subscription_screen',
            'offeringId': offeringId,
          },
        );
      } else {
        throw Exception('Paywall not found');
      }
    } catch (e) {
      devLogger('❌ Error showing paywall: $e');
      analytic.logEvent(
        name: 'paywall_show_failed',
        parameters: {
          'screen': 'subscription_screen',
          'offeringId': _offeringId ?? 'unknown',
          'error': e.toString(),
        },
      );
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      _onPaywallCompleted?.call();
      _onPaywallCompleted = null;
      _offeringId = null;
    }
  }

  Future<void> updateUserToPremium({required CustomerInfo customerInfo}) async {
    try {
      final productId =
          customerInfo.entitlements.active['pro']?.productIdentifier;

      await _authProvider.syncSubscription(customerInfo);

      devLogger('✅ User updated with plan: $productId');
    } catch (e) {
      devLogger('❌ Error updating user: $e');
    }
  }

  void onPurchaseStarted(Package package) {
    devLogger('➡️ Starting purchase: ${package.identifier}');
    analytic.logEvent(
      name: 'paywall_purchase_start',
      parameters: {
        'screen': 'subscription_screen',
        'paywallId': _offeringId ?? 'unknown',
        'identifier': package.identifier,
        'productId': package.storeProduct.identifier,
      },
    );
  }

  void onPurchaseCompleted(
    CustomerInfo customerInfo,
    StoreTransaction transaction,
  ) async {
    devLogger('✅ Purchase successful');
    analytic.logEvent(
      name: 'paywall_purchase_success',
      parameters: {
        'screen': 'subscription_screen',
        'paywallId': _offeringId ?? 'unknown',
        'productId': transaction.productIdentifier,
      },
    );
    await updateUserToPremium(customerInfo: customerInfo);
    _onPaywallCompleted?.call();
  }

  void onPurchaseError(PurchasesError purchasesError) {
    devLogger('❌ Purchase failed: $purchasesError');
    analytic.logEvent(
      name: 'paywall_purchase_failed',
      parameters: {
        'screen': 'subscription_screen',
        'paywallId': _offeringId ?? 'unknown',
        'error': purchasesError.message,
      },
    );
  }

  void onRestoreCompleted(CustomerInfo customerInfo) async {
    devLogger('✅ Restore successful');
    analytic.logEvent(
      name: 'paywall_purchase_restore_success',
      parameters: {'screen': 'subscription_screen', 'paywallId': _offeringId ?? 'unknown'},
    );
    await updateUserToPremium(customerInfo: customerInfo);
    _onPaywallCompleted?.call();
  }

  void onRestoreError(PurchasesError purchasesError) async {
    devLogger('❌ Restore failed: $purchasesError');
    analytic.logEvent(
      name: 'paywall_purchase_restore_failed',
      parameters: {
        'screen': 'subscription_screen',
        'paywallId': _offeringId ?? 'unknown',
        'error': purchasesError.message,
      },
    );
  }
}

