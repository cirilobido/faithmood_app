import '../../../core/core_exports.dart';

class AddMoodState {
  bool isLoading;
  bool error;
  List<Mood> moods;
  int currentPage;
  Mood? selectedEmotionalMood;
  Mood? selectedSpiritualMood;
  String note;

  AddMoodState({
    this.isLoading = false,
    this.error = false,
    this.moods = const [],
    this.currentPage = 0,
    this.selectedEmotionalMood,
    this.selectedSpiritualMood,
    this.note = '',
  });

  AddMoodState copyWith({
    bool? isLoading,
    bool? error,
    List<Mood>? moods,
    int? currentPage,
    Mood? selectedEmotionalMood,
    Mood? selectedSpiritualMood,
    String? note,
  }) {
    return AddMoodState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      moods: moods ?? this.moods,
      currentPage: currentPage ?? this.currentPage,
      selectedEmotionalMood: selectedEmotionalMood ?? this.selectedEmotionalMood,
      selectedSpiritualMood: selectedSpiritualMood ?? this.selectedSpiritualMood,
      note: note ?? this.note,
    );
  }

  List<Mood> get emotionalMoods {
    return moods.where((mood) => mood.category == 'emotional').toList();
  }

  List<Mood> get spiritualMoods {
    return moods.where((mood) => mood.category == 'spiritual').toList();
  }
}

