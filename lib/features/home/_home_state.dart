import '../../core/core_exports.dart';

class HomeState {
  bool isLoading;
  bool error;
  Verse? dailyVerse;
  bool isLoadingDevotional;
  bool errorDevotional;
  Devotional? dailyDevotional;
  List<Mood> moods;
  bool isLoadingMoods;
  Mood? selectedMood;
  Map<DateTime, List<MoodSession>> weekMoodSessions;
  bool isLoadingWeekMoods;
  DateTime? weekStartDate;
  DateTime? weekEndDate;

  HomeState({
    this.isLoading = false,
    this.error = false,
    this.dailyVerse,
    this.isLoadingDevotional = false,
    this.errorDevotional = false,
    this.dailyDevotional,
    this.moods = const [],
    this.isLoadingMoods = false,
    this.selectedMood,
    this.weekMoodSessions = const {},
    this.isLoadingWeekMoods = false,
    this.weekStartDate,
    this.weekEndDate,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? error,
    Verse? dailyVerse,
    bool? isLoadingDevotional,
    bool? errorDevotional,
    Devotional? dailyDevotional,
    List<Mood>? moods,
    bool? isLoadingMoods,
    Mood? selectedMood,
    Map<DateTime, List<MoodSession>>? weekMoodSessions,
    bool? isLoadingWeekMoods,
    DateTime? weekStartDate,
    DateTime? weekEndDate,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      dailyVerse: dailyVerse ?? this.dailyVerse,
      isLoadingDevotional: isLoadingDevotional ?? this.isLoadingDevotional,
      errorDevotional: errorDevotional ?? this.errorDevotional,
      dailyDevotional: dailyDevotional ?? this.dailyDevotional,
      moods: moods ?? this.moods,
      isLoadingMoods: isLoadingMoods ?? this.isLoadingMoods,
      selectedMood: selectedMood ?? this.selectedMood,
      weekMoodSessions: weekMoodSessions ?? this.weekMoodSessions,
      isLoadingWeekMoods: isLoadingWeekMoods ?? this.isLoadingWeekMoods,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
    );
  }
}

