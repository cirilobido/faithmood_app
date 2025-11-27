enum PaywallEnum {
  defaultId,
  welcome,
  settingsPlacement;

  const PaywallEnum();

  String get paywallId {
      switch (this) {
        case PaywallEnum.defaultId:
        return 'default';
        case PaywallEnum.welcome:
        return 'welcome';
      case PaywallEnum.settingsPlacement:
        return 'settings';
    }
  }
}

