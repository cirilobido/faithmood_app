import '../../../core/core_exports.dart';

class ProfileState {
  final User? user;
  final AnalyticsPeriod? selectedPeriod;
  final Analytics? thisWeekStats;
  final int? thisWeekStreak;
  final Analytics? lastWeekStats;
  final int? lastWeekStreak;
  final Analytics? thisMonthStats;
  final int? thisMonthStreak;
  final Analytics? lastMonthStats;
  final int? lastMonthStreak;
  final bool? isPremium;
  final List<Mood>? moods;
  final bool isLoading;
  final bool error;

  ProfileState({
    this.user,
    this.selectedPeriod,
    this.thisWeekStats,
    this.thisWeekStreak,
    this.lastWeekStats,
    this.lastWeekStreak,
    this.thisMonthStats,
    this.thisMonthStreak,
    this.lastMonthStats,
    this.lastMonthStreak,
    this.isPremium,
    this.moods,
    this.isLoading = false,
    this.error = false,
  });

  ProfileState copyWith({
    User? user,
    AnalyticsPeriod? selectedPeriod,
    Analytics? thisWeekStats,
    int? thisWeekStreak,
    Analytics? lastWeekStats,
    int? lastWeekStreak,
    Analytics? thisMonthStats,
    int? thisMonthStreak,
    Analytics? lastMonthStats,
    int? lastMonthStreak,
    bool? isPremium,
    List<Mood>? moods,
    bool? isLoading,
    bool? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      thisWeekStats: thisWeekStats ?? this.thisWeekStats,
      thisWeekStreak: thisWeekStreak ?? this.thisWeekStreak,
      lastWeekStats: lastWeekStats ?? this.lastWeekStats,
      lastWeekStreak: lastWeekStreak ?? this.lastWeekStreak,
      thisMonthStats: thisMonthStats ?? this.thisMonthStats,
      thisMonthStreak: thisMonthStreak ?? this.thisMonthStreak,
      lastMonthStats: lastMonthStats ?? this.lastMonthStats,
      lastMonthStreak: lastMonthStreak ?? this.lastMonthStreak,
      isPremium: isPremium ?? this.isPremium,
      moods: moods ?? this.moods,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

