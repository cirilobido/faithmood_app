import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/mood_use_case.dart';
import '../../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_journal_state.dart';

final journalViewModelProvider =
    StateNotifierProvider<JournalViewModel, JournalState>((ref) {
  return JournalViewModel(
    ref.read(moodUseCaseProvider),
    ref.read(devotionalUseCaseProvider),
    ref.read(authProvider),
  );
});

class JournalViewModel extends StateNotifier<JournalState> {
  final MoodUseCase moodUseCase;
  final DevotionalUseCase devotionalUseCase;
  final AuthProvider authProvider;
  bool _mounted = true;

  JournalViewModel(
    this.moodUseCase,
    this.devotionalUseCase,
    this.authProvider,
  ) : super(JournalState()) {
    loadMoodSessions();
    loadMoods();
    loadDevotionalLogs();
  }

  void updateState({
    int? selectedTab,
    bool? isLoading,
    bool? error,
    List<MoodSession>? moodSessions,
    String? searchQuery,
    int? selectedEmotionalMoodId,
    int? selectedSpiritualMoodId,
    bool? hasNoteFilter,
    String? sortBy,
    String? order,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
    List<Mood>? moods,
    bool? isLoadingMoods,
    bool? moodsError,
    List<DevotionalLog>? devotionalLogs,
    bool? isLoadingDevotionalLogs,
    bool? devotionalLogsError,
    int? devotionalLogsPage,
    int? devotionalLogsTotalPages,
    bool? hasMoreDevotionalLogs,
    bool? isLoadingMoreDevotionalLogs,
  }) {
    if (!_mounted) return;
    state = state.copyWith(
      selectedTab: selectedTab,
      isLoading: isLoading,
      error: error,
      moodSessions: moodSessions,
      searchQuery: searchQuery,
      selectedEmotionalMoodId: selectedEmotionalMoodId,
      selectedSpiritualMoodId: selectedSpiritualMoodId,
      hasNoteFilter: hasNoteFilter,
      sortBy: sortBy,
      order: order,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
      totalPages: totalPages,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      moods: moods,
      isLoadingMoods: isLoadingMoods,
      moodsError: moodsError,
      devotionalLogs: devotionalLogs,
      isLoadingDevotionalLogs: isLoadingDevotionalLogs,
      devotionalLogsError: devotionalLogsError,
      devotionalLogsPage: devotionalLogsPage,
      devotionalLogsTotalPages: devotionalLogsTotalPages,
      hasMoreDevotionalLogs: hasMoreDevotionalLogs,
      isLoadingMoreDevotionalLogs: isLoadingMoreDevotionalLogs,
    );
  }

  Map<String, dynamic> _buildQueryParams() {
    final userLang = authProvider.user?.lang?.name ?? 'en';
    final params = <String, dynamic>{
      'lang': userLang,
      'sortBy': state.sortBy,
      'order': state.order,
      'page': state.page,
      'limit': state.limit,
    };

    if (state.selectedEmotionalMoodId != null) {
      params['emotionalMoodId'] = state.selectedEmotionalMoodId;
    }

    if (state.selectedSpiritualMoodId != null) {
      params['spiritualMoodId'] = state.selectedSpiritualMoodId;
    }

    if (state.hasNoteFilter != null) {
      params['hasNote'] = state.hasNoteFilter;
    }

    if (state.startDate != null) {
      params['startDate'] = state.startDate!.toIso8601String().split('T')[0];
    }

    if (state.endDate != null) {
      params['endDate'] = state.endDate!.toIso8601String().split('T')[0];
    }

    return params;
  }

  Future<void> loadMoodSessions() async {
    try {
      updateState(isLoading: true, error: false, page: 1);
      final userId = authProvider.user?.id;
      if (userId == null) {
        updateState(isLoading: false, error: true);
        return;
      }

      final queryParams = _buildQueryParams();
      final result = await moodUseCase.getMoodSessions(userId, queryParams);

      switch (result) {
        case Success(value: final response):
          {
            if (!_mounted) return;
            final sessions = response?.sessions ?? [];
            final currentPage = response?.page ?? 1;
            final totalPages = response?.totalPages ?? 1;
            final hasMore = currentPage < totalPages;
            updateState(
              isLoading: false,
              moodSessions: sessions,
              page: currentPage,
              totalPages: totalPages,
              hasMore: hasMore,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading mood sessions: $exception');
            if (!_mounted) return;
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading mood sessions: $e');
      if (!_mounted) return;
      updateState(isLoading: false, error: true);
    }
  }

  Future<void> loadMoreMoodSessions() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    try {
      updateState(isLoadingMore: true);
      final userId = authProvider.user?.id;
      if (userId == null) {
        updateState(isLoadingMore: false);
        return;
      }

      final nextPage = state.page + 1;
      final queryParams = _buildQueryParams()..['page'] = nextPage;
      final result = await moodUseCase.getMoodSessions(userId, queryParams);

      switch (result) {
        case Success(value: final response):
          {
            if (!_mounted) return;
            final newSessions = response?.sessions ?? [];
            final currentPage = response?.page ?? nextPage;
            final totalPages = response?.totalPages ?? 1;
            final hasMore = currentPage < totalPages;
            updateState(
              isLoadingMore: false,
              moodSessions: [...state.moodSessions, ...newSessions],
              page: currentPage,
              totalPages: totalPages,
              hasMore: hasMore,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading more mood sessions: $exception');
            if (!_mounted) return;
            updateState(isLoadingMore: false);
          }
      }
    } catch (e) {
      devLogger('Error loading more mood sessions: $e');
      if (!_mounted) return;
      updateState(isLoadingMore: false);
    }
  }

  void searchMoodSessions(String query) {
    updateState(searchQuery: query);
  }

  void filterByEmotionalMood(int? moodId) {
    if (moodId == null) {
      clearEmotionalMoodFilter();
    } else {
      updateState(selectedEmotionalMoodId: moodId);
      loadMoodSessions();
    }
  }

  void filterBySpiritualMood(int? moodId) {
    if (moodId == null) {
      clearSpiritualMoodFilter();
    } else {
      updateState(selectedSpiritualMoodId: moodId);
      loadMoodSessions();
    }
  }

  void filterByHasNote(bool? hasNote) {
    if (hasNote == null) {
      clearHasNoteFilter();
    } else {
      updateState(hasNoteFilter: hasNote);
      loadMoodSessions();
    }
  }

  void clearEmotionalMoodFilter() {
    state = state.clearEmotionalMoodFilter();
    loadMoodSessions();
  }

  void clearSpiritualMoodFilter() {
    state = state.clearSpiritualMoodFilter();
    loadMoodSessions();
  }

  void clearHasNoteFilter() {
    state = state.clearHasNoteFilter();
    loadMoodSessions();
  }

  void sortMoodSessions(String sortBy, String order) {
    updateState(sortBy: sortBy, order: order);
    loadMoodSessions();
    if (state.selectedTab == 1) {
      loadDevotionalLogs();
    }
  }

  void switchTab(int index) {
    updateState(selectedTab: index);
    if (index == 1) {
      if (state.devotionalLogs.isEmpty && !state.isLoadingDevotionalLogs && !state.devotionalLogsError) {
        loadDevotionalLogs();
      }
    }
  }

  void filterByDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null && endDate == null) {
      clearDateFilters();
    } else {
      updateState(startDate: startDate, endDate: endDate);
      loadMoodSessions();
      if (state.selectedTab == 1) {
        loadDevotionalLogs();
      }
    }
  }

  void clearDateFilters() {
    state = state.clearDateFilters();
    loadMoodSessions();
    if (state.selectedTab == 1) {
      loadDevotionalLogs();
    }
  }

  void clearFilters() {
    updateState(
      selectedEmotionalMoodId: null,
      selectedSpiritualMoodId: null,
      hasNoteFilter: null,
      searchQuery: '',
      startDate: null,
      endDate: null,
    );
    loadMoodSessions();
  }

  Future<void> loadMoods() async {
    try {
      updateState(isLoadingMoods: true, moodsError: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final result = await moodUseCase.getMoods(userLang);

      switch (result) {
        case Success(value: final moods):
          {
            if (!_mounted) return;
            updateState(isLoadingMoods: false, moods: moods);
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading moods: $exception');
            if (!_mounted) return;
            updateState(isLoadingMoods: false, moodsError: true);
          }
      }
    } catch (e) {
      devLogger('Error loading moods: $e');
      if (!_mounted) return;
      updateState(isLoadingMoods: false, moodsError: true);
    }
  }

  List<Mood> get emotionalMoods {
    return (state.moods?.where((mood) => mood.category == 'emotional') ?? []).toList();
  }

  List<Mood> get spiritualMoods {
    return (state.moods?.where((mood) => mood.category == 'spiritual') ?? []).toList();
  }

  Map<String, dynamic> _buildDevotionalLogsQueryParams() {
    final userLang = authProvider.user?.lang?.name ?? 'en';
    final params = <String, dynamic>{
      'lang': userLang,
      'page': state.devotionalLogsPage,
      'limit': state.limit,
      'order': state.order,
    };

    if (state.startDate != null) {
      params['startDate'] = state.startDate!.toIso8601String().split('T')[0];
    }

    if (state.endDate != null) {
      params['endDate'] = state.endDate!.toIso8601String().split('T')[0];
    }

    return params;
  }

  Future<void> loadDevotionalLogs() async {
    try {
      if (!_mounted) return;
      devLogger('Loading devotional logs...');
      updateState(isLoadingDevotionalLogs: true, devotionalLogsError: false, devotionalLogsPage: 1);
      final userId = authProvider.user?.id;
      if (userId == null) {
        devLogger('Error: User ID is null');
        if (!_mounted) return;
        updateState(isLoadingDevotionalLogs: false, devotionalLogsError: true);
        return;
      }

      final queryParams = _buildDevotionalLogsQueryParams();
      devLogger('Query params: $queryParams');
      final result = await devotionalUseCase.getDevotionalLogs(userId, queryParams);

      switch (result) {
        case Success(value: final response):
          {
            if (!_mounted) return;
            final logs = response?.logs ?? [];
            devLogger('Devotional logs loaded: ${logs.length} logs');
            final currentPage = response?.page ?? 1;
            final totalPages = response?.totalPages ?? 1;
            final hasMore = currentPage < totalPages;
            updateState(
              isLoadingDevotionalLogs: false,
              devotionalLogs: logs,
              devotionalLogsPage: currentPage,
              devotionalLogsTotalPages: totalPages,
              hasMoreDevotionalLogs: hasMore,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading devotional logs: $exception');
            if (!_mounted) return;
            updateState(isLoadingDevotionalLogs: false, devotionalLogsError: true);
          }
      }
    } catch (e) {
      devLogger('Error loading devotional logs: $e');
      if (!_mounted) return;
      updateState(isLoadingDevotionalLogs: false, devotionalLogsError: true);
    }
  }

  Future<void> loadMoreDevotionalLogs() async {
    if (!state.hasMoreDevotionalLogs || state.isLoadingMoreDevotionalLogs || state.isLoadingDevotionalLogs) return;

    try {
      if (!_mounted) return;
      updateState(isLoadingMoreDevotionalLogs: true);
      final userId = authProvider.user?.id;
      if (userId == null) {
        if (!_mounted) return;
        updateState(isLoadingMoreDevotionalLogs: false);
        return;
      }

      final nextPage = state.devotionalLogsPage + 1;
      final queryParams = _buildDevotionalLogsQueryParams()..['page'] = nextPage;
      final result = await devotionalUseCase.getDevotionalLogs(userId, queryParams);

      switch (result) {
        case Success(value: final response):
          {
            if (!_mounted) return;
            final newLogs = response?.logs ?? [];
            final currentPage = response?.page ?? nextPage;
            final totalPages = response?.totalPages ?? 1;
            final hasMore = currentPage < totalPages;
            updateState(
              isLoadingMoreDevotionalLogs: false,
              devotionalLogs: [...state.devotionalLogs, ...newLogs],
              devotionalLogsPage: currentPage,
              devotionalLogsTotalPages: totalPages,
              hasMoreDevotionalLogs: hasMore,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading more devotional logs: $exception');
            if (!_mounted) return;
            updateState(isLoadingMoreDevotionalLogs: false);
          }
      }
    } catch (e) {
      devLogger('Error loading more devotional logs: $e');
      if (!_mounted) return;
      updateState(isLoadingMoreDevotionalLogs: false, devotionalLogsError: true);
    }
  }
}

