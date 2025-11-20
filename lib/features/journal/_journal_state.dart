import '../../../core/core_exports.dart';

class JournalState {
  int selectedTab;
  bool isLoading;
  bool error;
  List<MoodSession> moodSessions;
  String searchQuery;
  int? selectedEmotionalMoodId;
  int? selectedSpiritualMoodId;
  bool? hasNoteFilter;
  String sortBy;
  String order;
  DateTime? startDate;
  DateTime? endDate;
  int page;
  int limit;
  int? totalPages;
  bool hasMore;
  bool isLoadingMore;
  List<Mood>? moods;
  bool isLoadingMoods;
  bool moodsError;
  List<DevotionalLog> devotionalLogs;
  bool isLoadingDevotionalLogs;
  bool devotionalLogsError;
  int devotionalLogsPage;
  int? devotionalLogsTotalPages;
  bool hasMoreDevotionalLogs;
  bool isLoadingMoreDevotionalLogs;

  JournalState({
    this.selectedTab = 0,
    this.isLoading = false,
    this.error = false,
    this.moodSessions = const [],
    this.searchQuery = '',
    this.selectedEmotionalMoodId,
    this.selectedSpiritualMoodId,
    this.hasNoteFilter,
    this.sortBy = 'updatedAt',
    this.order = 'desc',
    this.startDate,
    this.endDate,
    this.page = 1,
    this.limit = 10,
    this.totalPages,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.moods = const [],
    this.isLoadingMoods = false,
    this.moodsError = false,
    this.devotionalLogs = const [],
    this.isLoadingDevotionalLogs = false,
    this.devotionalLogsError = false,
    this.devotionalLogsPage = 1,
    this.devotionalLogsTotalPages,
    this.hasMoreDevotionalLogs = true,
    this.isLoadingMoreDevotionalLogs = false,
  });

  JournalState copyWith({
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
    bool clearEmotionalMoodId = false,
    bool clearSpiritualMoodId = false,
    bool clearHasNoteFilter = false,
    bool clearDateFilters = false,
  }) {
    return JournalState(
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      moodSessions: moodSessions ?? this.moodSessions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedEmotionalMoodId: clearEmotionalMoodId
          ? null
          : (selectedEmotionalMoodId ?? this.selectedEmotionalMoodId),
      selectedSpiritualMoodId: clearSpiritualMoodId
          ? null
          : (selectedSpiritualMoodId ?? this.selectedSpiritualMoodId),
      hasNoteFilter: clearHasNoteFilter
          ? null
          : (hasNoteFilter ?? this.hasNoteFilter),
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
      startDate: clearDateFilters
          ? null
          : (startDate ?? this.startDate),
      endDate: clearDateFilters
          ? null
          : (endDate ?? this.endDate),
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      moods: moods ?? this.moods,
      isLoadingMoods: isLoadingMoods ?? this.isLoadingMoods,
      moodsError: moodsError ?? this.moodsError,
      devotionalLogs: devotionalLogs ?? this.devotionalLogs,
      isLoadingDevotionalLogs: isLoadingDevotionalLogs ?? this.isLoadingDevotionalLogs,
      devotionalLogsError: devotionalLogsError ?? this.devotionalLogsError,
      devotionalLogsPage: devotionalLogsPage ?? this.devotionalLogsPage,
      devotionalLogsTotalPages: devotionalLogsTotalPages ?? this.devotionalLogsTotalPages,
      hasMoreDevotionalLogs: hasMoreDevotionalLogs ?? this.hasMoreDevotionalLogs,
      isLoadingMoreDevotionalLogs: isLoadingMoreDevotionalLogs ?? this.isLoadingMoreDevotionalLogs,
    );
  }

  JournalState clearEmotionalMoodFilter() {
    return copyWith(clearEmotionalMoodId: true);
  }

  JournalState clearSpiritualMoodFilter() {
    return copyWith(clearSpiritualMoodId: true);
  }

  JournalState clearHasNoteFilter() {
    return copyWith(clearHasNoteFilter: true);
  }

  JournalState clearDateFilters() {
    return copyWith(clearDateFilters: true);
  }
}

