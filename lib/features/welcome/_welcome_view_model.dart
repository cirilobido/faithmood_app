import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '../../generated/l10n.dart';
import '_welcome_state.dart';

final welcomeViewModelProvider =
    AutoDisposeStateNotifierProvider<WelcomeViewModel, WelcomeState>((ref) {
      return WelcomeViewModel(
        ref.read(firebaseAnalyticProvider),
        ref.read(authProvider),
        ref.read(settingsProvider),
      );
    });

class WelcomeViewModel extends StateNotifier<WelcomeState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;

  WelcomeViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.settingsProvider,
  ) : super(WelcomeState());

  bool get isFirstTimeOpen => settingsProvider.isFirstTimeOpen;

  final nameController = TextEditingController();
  final nameFocus = FocusNode();

  final ageController = TextEditingController();
  final ageFocus = FocusNode();

  final langController = TextEditingController(
    text: Lang.toTitle(value: Lang.en) ?? '',
  );
  Lang selectedLang = Lang.en;

  final List<String> selectedExperience = [];
  String? selectedCommitted;
  String? selectedEverUsed;
  String? selectedGuidedPlan;
  String? selectedSocial;

  List<int> backendPageOrder = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  void updateState({
    int? currentPage,
    double? progress,
    bool? isLoading,
    bool? error,
  }) {
    state = state.copyWith(
      currentPage: currentPage,
      progress: progress,
      isLoading: isLoading,
      error: error,
    );
  }

  Future<void> getIsFirstTimeOpen() async {
    try {
      await settingsProvider.getIsFirstTimeOpen();
    } catch (e) {
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
      devLogger(e.toString());
    }
  }

  Future<void> setIsFirstTimeOpenFalse() async {
    try {
      updateState(isLoading: true, error: false);
      await settingsProvider.setIsFirstTimeOpen(false);
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_false',
        parameters: {'screen': 'welcome_screen'},
      );
      updateState(isLoading: false);
    } catch (e) {
      updateState(isLoading: false, error: true);
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_false_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    }
  }

  Future<void> skipTapEvent() async {
    try {
      firebaseAnalyticProvider.logEvent(
        name: 'on_skip_tap_successfully',
        parameters: {'screen': 'welcome_screen'},
      );
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'on_skip_tap_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    }
  }

  int getCurrentBackendIndex() {
    final idx = state.currentPage;
    if (idx >= backendPageOrder.length) return 0;
    return backendPageOrder[idx];
  }

  void setBackendOrder(List<int> order) {
    backendPageOrder = order;
    _updateProgress();
  }

  void nextPage() {
    final next = state.currentPage + 1;
    if (next >= backendPageOrder.length) return;

    updateState(currentPage: next);
    _updateProgress();
  }

  void previousPage() {
    final prev = state.currentPage - 1;
    if (prev < 0) return;

    updateState(currentPage: prev);
    _updateProgress();
  }

  void _updateProgress() {
    final total = 8; // TOTAL NORMAL PAGES
    if (total <= 0) return;

    final value = state.currentPage / total;
    final progress = value.clamp(0, 1).toDouble();
    updateState(progress: progress);
  }

  String? validatePage(int backendIndex, BuildContext context) {
    final lang = S.of(context);

    if (backendIndex == 1) {
      InputValidations.validateName(context, nameController.text.trim());
      if (ageController.text.trim().isEmpty || int.parse(ageController.text) <= 0) {
        return lang.ageIsRequired;
      }
    }
    // TODO: VALIDATIONS FOR PAGES
    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocus.dispose();
    ageController.dispose();
    ageFocus.dispose();
    langController.dispose();
    super.dispose();
  }
}
