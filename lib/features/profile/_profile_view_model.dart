import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '../../../core/providers/domain/use_cases/analytics_use_case.dart';
import '../../../core/providers/domain/use_cases/mood_use_case.dart';
import '_profile_state.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  return ProfileViewModel(
    ref,
    ref.read(firebaseAnalyticProvider),
    ref.read(authProvider),
    ref.read(settingsProvider),
    ref.read(analyticsUseCaseProvider),
    ref.read(moodUseCaseProvider),
  );
});

class ProfileViewModel extends StateNotifier<ProfileState> {
  final Ref ref;
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider _authProvider;
  final SettingsProvider settingsProvider;
  final AnalyticsUseCase _analyticsUseCase;
  final MoodUseCase _moodUseCase;
  bool _mounted = true;

  ProfileViewModel(
    this.ref,
    this.firebaseAnalyticProvider,
    this._authProvider,
    this.settingsProvider,
    this._analyticsUseCase,
    this._moodUseCase,
  ) : super(ProfileState()) {
    ref.listen(authProvider, (previous, next) {
      _onUserChanged(next.user);
    });
    _loadUser();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  void _onUserChanged(User? user) {
    if (user == null) return;

    updateState(user: user);
    _getUserLimitations();

    firebaseAnalyticProvider.logEvent(
      name: 'user_changed',
      parameters: {'screen': 'profile_screen', 'userId': user.id?.toString() ?? ''},
    );
  }

  bool get isDataLoaded => state.thisWeekStats != null;

  bool get isBannerAdEnabled => settingsProvider.isBannerAdEnable;

  void updateState({
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
    if (!_mounted) return;
    state = state.copyWith(
      user: user,
      selectedPeriod: selectedPeriod,
      thisWeekStats: thisWeekStats,
      thisWeekStreak: thisWeekStreak,
      lastWeekStats: lastWeekStats,
      lastWeekStreak: lastWeekStreak,
      thisMonthStats: thisMonthStats,
      thisMonthStreak: thisMonthStreak,
      lastMonthStats: lastMonthStats,
      lastMonthStreak: lastMonthStreak,
      isPremium: isPremium,
      moods: moods,
      isLoading: isLoading,
      error: error,
    );
  }

  Future<void> loadData({bool refresh = false}) async {
    updateState(isLoading: true, error: false);
    try {
      await _getUserLimitations();
      await loadMoods();
      await getAnalytics(AnalyticsPeriod.thisWeek);
      updateState(isLoading: false);
    } catch (e) {
      updateState(isLoading: false, error: true);
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'load_data_failed',
        parameters: {'screen': 'profile_screen', 'error': e.toString()},
      );
    }
  }

  Future<void> loadMoods() async {
    try {
      final userLang = _authProvider.user?.lang?.name ?? 'en';
      final result = await _moodUseCase.getMoods(userLang);

      switch (result) {
        case Success(value: final moods):
          {
            if (!_mounted) return;
            updateState(moods: moods);
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading moods: $exception');
            if (!_mounted) return;
          }
      }
    } catch (e) {
      devLogger('Error loading moods: $e');
      if (!_mounted) return;
    }
  }

  Mood? getMoodById(int? moodId, {bool isEmotional = true}) {
    if (moodId == null || state.moods == null) return null;
    final category = isEmotional ? 'emotional' : 'spiritual';
    return state.moods?.firstWhere(
      (mood) => mood.id == moodId && mood.category == category,
      orElse: () => state.moods!.firstWhere(
        (mood) => mood.id == moodId,
        orElse: () => state.moods!.first,
      ),
    );
  }

  List<Mood> get emotionalMoods {
    return (state.moods?.where((mood) => mood.category == 'emotional') ?? []).toList();
  }

  List<Mood> get spiritualMoods {
    return (state.moods?.where((mood) => mood.category == 'spiritual') ?? []).toList();
  }

  Future<void> _getUserLimitations() async {
    try {
      final settings = settingsProvider.settings;
      if (settings != null) {
        final user = _authProvider.user;
        final isPremium = user?.planType != PlanName.FREE;
        updateState(user: user, isPremium: isPremium);
        firebaseAnalyticProvider.logEvent(
          name: 'get_user_limitations_successfully',
          parameters: {'screen': 'profile_screen'},
        );
        return;
      }
      firebaseAnalyticProvider.logEvent(
        name: 'get_user_limitations_failed',
        parameters: {'screen': 'profile_screen'},
      );
      throw Exception('Error getting user limitations!');
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'get_user_limitations_failed',
        parameters: {'screen': 'profile_screen', 'error': e.toString()},
      );
      rethrow;
    }
  }

  Analytics? getCurrentStats(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.thisWeek:
        return state.thisWeekStats;
      case AnalyticsPeriod.lastWeek:
        return state.lastWeekStats;
      case AnalyticsPeriod.thisMonth:
        return state.thisMonthStats;
      case AnalyticsPeriod.lastMonth:
        return state.lastMonthStats;
    }
  }

  int? getCurrentStreak(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.thisWeek:
        return state.thisWeekStreak;
      case AnalyticsPeriod.lastWeek:
        return state.lastWeekStreak;
      case AnalyticsPeriod.thisMonth:
        return state.thisMonthStreak;
      case AnalyticsPeriod.lastMonth:
        return state.lastMonthStreak;
    }
  }

  Future<void> getAnalytics(AnalyticsPeriod period) async {
    updateState(isLoading: true, error: false, selectedPeriod: period);

    if (getCurrentStats(period) != null) {
      updateState(isLoading: false, error: false);
      return;
    }

    try {
      if (state.user?.id == null) {
        throw Exception('Error getting analytics!');
      }

      final dateRange = DateTimeHelper.getDateRange(period);
      final result = await _analyticsUseCase.getUserAnalytics(
        state.user!.id!,
        DateHelper.formatForApi(dateRange['start']!),
        DateHelper.formatForApi(dateRange['end']!),
      );

      switch (result) {
        case Success(value: final value):
          {
            if (value == null) {
              throw Exception('Error getting analytics!');
            }

            _updateStateByPeriod(
              period: period,
              value: value,
              streak: DateHelper.calculateLongestStreak(
                value.datesWithLogs,
                dateRange['start']!,
                dateRange['end']!,
              ),
            );

            updateState(isLoading: false, error: false);
          }
        case Failure():
          {
            throw Exception('Error getting analytics!');
          }
      }
    } catch (e) {
      updateState(isLoading: false, error: true);
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'error_getting_analytics',
        parameters: {
          'screen': 'profile_screen',
          'period': period.key ?? '',
          'error': e.toString(),
        },
      );
    }
  }

  void _updateStateByPeriod({
    required AnalyticsPeriod period,
    required Analytics value,
    int? streak,
  }) {
    switch (period) {
      case AnalyticsPeriod.thisWeek:
        updateState(thisWeekStats: value, thisWeekStreak: streak);
        break;
      case AnalyticsPeriod.lastWeek:
        updateState(lastWeekStats: value, lastWeekStreak: streak);
        break;
      case AnalyticsPeriod.thisMonth:
        updateState(thisMonthStats: value, thisMonthStreak: streak);
        break;
      case AnalyticsPeriod.lastMonth:
        updateState(lastMonthStats: value, lastMonthStreak: streak);
        break;
    }
  }

  void _loadUser() {
    final user = _authProvider.user;
    if (user != null) {
      updateState(user: user);
    }
  }
}
