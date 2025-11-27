import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionState {
  bool isLoading;
  Offering? offering;
  String? errorMessage;

  SubscriptionState({
    this.isLoading = false,
    this.offering,
    this.errorMessage,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    Offering? offering,
    String? errorMessage,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      offering: offering ?? this.offering,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

