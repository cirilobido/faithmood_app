import '../../core/core_exports.dart';

class HomeState {
  bool isLoading;
  bool error;
  Verse? dailyVerse;
  bool isLoadingDevotional;
  bool errorDevotional;
  Devotional? dailyDevotional;

  HomeState({
    this.isLoading = false,
    this.error = false,
    this.dailyVerse,
    this.isLoadingDevotional = false,
    this.errorDevotional = false,
    this.dailyDevotional,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? error,
    Verse? dailyVerse,
    bool? isLoadingDevotional,
    bool? errorDevotional,
    Devotional? dailyDevotional,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      dailyVerse: dailyVerse ?? this.dailyVerse,
      isLoadingDevotional: isLoadingDevotional ?? this.isLoadingDevotional,
      errorDevotional: errorDevotional ?? this.errorDevotional,
      dailyDevotional: dailyDevotional ?? this.dailyDevotional,
    );
  }
}

