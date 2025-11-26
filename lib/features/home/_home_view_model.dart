import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:in_app_review/in_app_review.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../../core/providers/domain/use_cases/verse_use_case.dart';
import '../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../core/providers/domain/use_cases/mood_use_case.dart';
import '../../core/providers/domain/use_cases/analytics_use_case.dart';
import '../../core/providers/_auth_provider.dart' as auth_prov;
import '../../core/providers/data/data_sources/local/review_dao.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '_home_state.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel(
    ref.read(firebaseAnalyticProvider),
    ref.read(authProvider),
    ref.read(verseUseCaseProvider),
    ref.read(devotionalUseCaseProvider),
    ref.read(moodUseCaseProvider),
    ref.read(analyticsUseCaseProvider),
    ref.read(reviewDaoProvider),
    ref,
  );
});

class HomeViewModel extends StateNotifier<HomeState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final VerseUseCase verseUseCase;
  final DevotionalUseCase devotionalUseCase;
  final MoodUseCase moodUseCase;
  final AnalyticsUseCase analyticsUseCase;
  final ReviewDao reviewDao;
  final Ref ref;

  HomeViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.verseUseCase,
    this.devotionalUseCase,
    this.moodUseCase,
    this.analyticsUseCase,
    this.reviewDao,
    this.ref,
  ) : super(HomeState()) {
    _loadDailyVerse();
    _loadDailyDevotional();
    _loadMoods();
    _loadWeekMoods();
    _setupLanguageListeners();
  }

  void _setupLanguageListeners() {
    ref.listen(auth_prov.authProvider, (previous, next) {
      final previousLang = previous?.user?.lang?.name;
      final currentLang = next.user?.lang?.name ?? Lang.en.name;
      
      if (previousLang != currentLang) {
        _loadMoods();
      }
    });
  }

  void updateState({
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
    state = state.copyWith(
      isLoading: isLoading,
      error: error,
      dailyVerse: dailyVerse,
      isLoadingDevotional: isLoadingDevotional,
      errorDevotional: errorDevotional,
      dailyDevotional: dailyDevotional,
      moods: moods,
      isLoadingMoods: isLoadingMoods,
      selectedMood: selectedMood,
      weekMoodSessions: weekMoodSessions,
      isLoadingWeekMoods: isLoadingWeekMoods,
      weekStartDate: weekStartDate,
      weekEndDate: weekEndDate,
    );
  }

  String getGreeting(S lang) {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 12) {
      return lang.greetingMorning;
    } else if (hour >= 12 && hour <= 18) {
      return lang.greetingAfternoon;
    } else {
      return lang.greetingEvening;
    }
  }

  String getGreetingSubtitle(S lang) {
    final hour = DateTime.now().hour;

    // Usamos arrays del idioma correspondiente
    final morning = [
      lang.greetingMorningSubtitle1,
      lang.greetingMorningSubtitle2,
      lang.greetingMorningSubtitle3,
      lang.greetingMorningSubtitle4,
      lang.greetingMorningSubtitle5,
    ];

    final afternoon = [
      lang.greetingAfternoonSubtitle1,
      lang.greetingAfternoonSubtitle2,
      lang.greetingAfternoonSubtitle3,
      lang.greetingAfternoonSubtitle4,
      lang.greetingAfternoonSubtitle5,
    ];

    final evening = [
      lang.greetingEveningSubtitle1,
      lang.greetingEveningSubtitle2,
      lang.greetingEveningSubtitle3,
      lang.greetingEveningSubtitle4,
      lang.greetingEveningSubtitle5,
    ];

    List<String> selected;

    if (hour >= 4 && hour < 12) {
      selected = morning;
    } else if (hour >= 12 && hour <= 18) {
      selected = afternoon;
    } else {
      selected = evening;
    }

    final index = DateTime.now().day % selected.length;
    return selected[index];
  }

  String? getUserName() {
    return authProvider.user?.name;
  }

  Future<void> _loadDailyVerse() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final result = await verseUseCase.getDailyVerse(userLang);

      switch (result) {
        case Success(value: final verse):
          {
            if (verse != null) {
              updateState(isLoading: false, dailyVerse: verse);
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
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
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

  Future<void> _loadMoods() async {
    try {
      updateState(isLoadingMoods: true);
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final result = await moodUseCase.getMoods(userLang);

      switch (result) {
        case Success(value: final moods):
          {
            ref.read(cachedMoodsProvider.notifier).setMoods(moods, userLang);
            
            final targetKeys = [
              'happy',
              'grateful',
              'peaceful',
              'worried',
              'sad',
            ];
            final filteredMoods = <Mood>[];

            for (final key in targetKeys) {
              try {
                final mood = moods.firstWhere((m) => m.key == key);
                filteredMoods.add(mood);
              } catch (e) {
                devLogger('Mood with key $key not found: $e');
              }
            }

            updateState(isLoadingMoods: false, moods: filteredMoods);
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading moods: $exception');
            updateState(isLoadingMoods: false);
          }
      }
    } catch (e) {
      devLogger('Error loading moods: $e');
      updateState(isLoadingMoods: false);
    }
  }

  void selectMood(Mood? mood) {
    updateState(selectedMood: mood);
  }

  List<Mood> getFilteredMoods() {
    return state.moods;
  }

  Mood? getSelectedMood() {
    return state.selectedMood;
  }

  List<DateTime> getCurrentWeekDates() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = today.weekday;
    final monday = today.subtract(Duration(days: weekday - 1));
    final weekDates = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );
    return weekDates;
  }

  String getDayName(DateTime date, Lang? lang) {
    final locale = lang?.name ?? Lang.en.name;
    final dateFormat = DateFormat('E', locale);
    return toBeginningOfSentenceCase(dateFormat.format(date)) ??
        dateFormat.format(date);
  }

  String getDayNumber(DateTime date) {
    return date.day.toString().padLeft(2, '0');
  }

  Future<List<Mood>> _loadMoodsForAnalytics() async {
    try {
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final moods = await moodUseCase.getMoods(userLang);
      switch (moods) {
        case Success(value: final moodList):
          return moodList;
        case Failure():
          return [];
      }
    } catch (_) {
      return [];
    }
  }

  Map<DateTime, List<MoodSession>> _convertAnalyticsToMoodSessions(
    Analytics? analytics,
    List<Mood> moods,
  ) {
    final groupedSessions = <DateTime, List<MoodSession>>{};
    if (analytics?.dailyStats == null) return groupedSessions;

    for (final dailyStat in analytics!.dailyStats!) {
      if (dailyStat.date == null ||
          dailyStat.moodCount == null ||
          dailyStat.moodCount! == 0) {
        continue;
      }

      try {
        final date = DateTime.parse(dailyStat.date!);
        final dateOnly = DateTime(date.year, date.month, date.day);

        Mood? predominantMood;
        if (dailyStat.predominantEmotionalMoodId != null) {
          predominantMood = moods.firstWhere(
            (m) => m.id == dailyStat.predominantEmotionalMoodId,
            orElse: () => moods.isNotEmpty ? moods.first : Mood(),
          );
        }

        final sessions = List.generate(
          dailyStat.moodCount!,
          (index) => MoodSession(
            sessionId: '${dateOnly.toIso8601String()}_$index',
            date: dateOnly,
            emotional: predominantMood != null
                ? MoodSessionDetails(mood: predominantMood)
                : null,
          ),
        );

        groupedSessions[dateOnly] = sessions;
      } catch (e) {
        devLogger('Error parsing date from dailyStats: $e');
      }
    }

    return groupedSessions;
  }

  Future<void> _loadWeekMoods({bool forceRefresh = false}) async {
    try {
      updateState(isLoadingWeekMoods: true);
      final userId = authProvider.user?.id;
      if (userId == null) {
        updateState(isLoadingWeekMoods: false);
        return;
      }

      final weekDates = getCurrentWeekDates();
      final weekStart = weekDates.first;
      final weekEnd = weekDates.last
          .add(Duration(days: 1))
          .subtract(Duration(seconds: 1));
      final startDate = DateHelper.formatForApi(weekStart);
      final endDate = DateHelper.formatForApi(weekEnd);

      final result = await analyticsUseCase.getUserAnalytics(
        userId,
        startDate,
        endDate,
        forceRefresh: forceRefresh,
      );

      switch (result) {
        case Success(value: final analytics):
          {
            if (analytics != null) {
              List<Mood> moods = state.moods;
              if (moods.isEmpty) {
                moods = await _loadMoodsForAnalytics();
              }
              final groupedSessions = _convertAnalyticsToMoodSessions(
                analytics,
                moods,
              );
              updateState(
                isLoadingWeekMoods: false,
                weekMoodSessions: groupedSessions,
                weekStartDate: weekStart,
                weekEndDate: weekEnd,
              );
            } else {
              updateState(isLoadingWeekMoods: false);
            }
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading week analytics: $exception');
            updateState(isLoadingWeekMoods: false);
          }
      }
    } catch (e) {
      devLogger('Error loading week moods: $e');
      updateState(isLoadingWeekMoods: false);
    }
  }

  Future<void> refreshWeekMoods() async {
    await _loadWeekMoods(forceRefresh: true);
  }

  Future<void> refreshDailyVerse() async {
    await _loadDailyVerse();
  }

  Future<void> refreshMoods() async {
    await _loadMoods();
  }

  Future<bool> shouldShowReviewModal() async {
    return await reviewDao.shouldShowReviewPrompt();
  }

  Future<void> onReviewTapped() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        firebaseAnalyticProvider.logEvent(
          name: 'request_review',
          parameters: {'screen': 'home_screen'},
        );
        await inAppReview.requestReview();
      } else {
        firebaseAnalyticProvider.logEvent(
          name: 'open_store_listing_review',
          parameters: {'screen': 'home_screen'},
        );
        await inAppReview.openStoreListing();
      }
      await reviewDao.saveLastReviewPromptDate(DateTime.now());
    } catch (e, s) {
      devLogger('⚠️ Rate app failed: $e\n$s');
      firebaseAnalyticProvider.logEvent(
        name: 'error_request_review',
        parameters: {'screen': 'home_screen', 'error': e.toString()},
      );
    }
  }

  Future<void> onNeverAskTapped() async {
    await reviewDao.setReviewNeverAsk(true);
    firebaseAnalyticProvider.logEvent(
      name: 'review_never_ask',
      parameters: {'screen': 'home_screen'},
    );
  }

  bool isUserPremium() {
    final user = authProvider.user;
    return user?.planType == PlanName.PREMIUM;
  }

  Future<bool> shouldShowPremiumModal() async {
    if (isUserPremium()) return false;
    return await reviewDao.shouldShowPremiumPrompt();
  }

  Future<String> getPremiumModalType() async {
    return await reviewDao.getPremiumModalTypeToShow();
  }

  Future<void> onPremiumTapped({required String modalType}) async {
    await reviewDao.saveLastPremiumPromptDate(DateTime.now());
    await reviewDao.saveLastPremiumModalType(modalType);
    firebaseAnalyticProvider.logEvent(
      name: 'premium_modal_tapped',
      parameters: {'screen': 'home_screen', 'modal_type': modalType},
    );
  }
}
