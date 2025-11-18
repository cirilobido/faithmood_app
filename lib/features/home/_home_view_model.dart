import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../core/providers/domain/use_cases/verse_use_case.dart';
import '../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '_home_state.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
      return HomeViewModel(
        ref.read(firebaseAnalyticProvider),
        ref.read(authProvider),
        ref.read(verseUseCaseProvider),
        ref.read(devotionalUseCaseProvider),
      );
    });

class HomeViewModel extends StateNotifier<HomeState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final VerseUseCase verseUseCase;
  final DevotionalUseCase devotionalUseCase;

  HomeViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.verseUseCase,
    this.devotionalUseCase,
  ) : super(HomeState()) {
    _loadDailyVerse();
    _loadDailyDevotional();
  }

  void updateState({
    bool? isLoading,
    bool? error,
    Verse? dailyVerse,
    bool? isLoadingDevotional,
    bool? errorDevotional,
    Devotional? dailyDevotional,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      error: error,
      dailyVerse: dailyVerse,
      isLoadingDevotional: isLoadingDevotional,
      errorDevotional: errorDevotional,
      dailyDevotional: dailyDevotional,
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String? getUserName() {
    return authProvider.user?.name;
  }

  Future<void> _loadDailyVerse() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final result = await verseUseCase.getDailyVerse(userLang);
      
      switch (result) {
        case Success(value: final verse):
          {
            if (verse != null) {
              updateState(
                isLoading: false,
                dailyVerse: verse,
              );
            } else {
              updateState(isLoading: false, error: true);
            }
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading daily verse: $exception');
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading daily verse: $e');
      updateState(isLoading: false, error: true);
    }
  }

  Verse? getDailyVerse() {
    return state.dailyVerse;
  }

  String getVerseText() {
    final verse = state.dailyVerse;
    if (verse == null) return '';
    return verse.text ?? '';
  }

  String getVerseRef() {
    final verse = state.dailyVerse;
    if (verse == null) return '';
    
    // Use the formatted reference: "Book Name Chapter:Verse"
    return verse.getFormattedRef();
  }

  Future<void> _loadDailyDevotional() async {
    try {
      updateState(isLoadingDevotional: true, errorDevotional: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final result = await devotionalUseCase.getDailyDevotional(userLang);
      
      switch (result) {
        case Success(value: final devotional):
          {
            if (devotional != null) {
              updateState(
                isLoadingDevotional: false,
                dailyDevotional: devotional,
              );
            } else {
              updateState(isLoadingDevotional: false, errorDevotional: true);
            }
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading daily devotional: $exception');
            updateState(isLoadingDevotional: false, errorDevotional: true);
          }
      }
    } catch (e) {
      devLogger('Error loading daily devotional: $e');
      updateState(isLoadingDevotional: false, errorDevotional: true);
    }
  }

  Devotional? getDailyDevotional() {
    return state.dailyDevotional;
  }

  String getDevotionalTitle() {
    final devotional = state.dailyDevotional;
    if (devotional == null) return '';
    return devotional.title ?? '';
  }

  String getDevotionalContent() {
    final devotional = state.dailyDevotional;
    if (devotional == null) return '';
    return devotional.content ?? '';
  }

  String? getDevotionalCoverImage() {
    final devotional = state.dailyDevotional;
    return devotional?.coverImage;
  }

  String? getDevotionalCategoryTitle() {
    final devotional = state.dailyDevotional;
    return devotional?.category?.title;
  }

  bool isDevotionalPremium() {
    final devotional = state.dailyDevotional;
    return devotional?.isPremium ?? false;
  }
}

