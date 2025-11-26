import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import 'domain/use_cases/mood_use_case.dart';

final moodsProvider = FutureProvider.autoDispose.family<List<Mood>, String>((ref, lang) async {
  final moodUseCase = ref.read(moodUseCaseProvider);
  final result = await moodUseCase.getMoods(lang);
  
  switch (result) {
    case Success(value: final moods):
      ref.read(cachedMoodsProvider.notifier).setMoods(moods, lang);
      return moods;
    case Failure(exception: final exception):
      devLogger('Error loading moods in provider: $exception');
      return [];
  }
});

final moodsRefreshProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  
  ref.listen<AuthProvider>(authProvider, (previous, next) {
    final previousLang = previous?.user?.lang?.name;
    final currentLang = next.user?.lang?.name ?? Lang.en.name;
    
    if (previousLang != currentLang) {
      ref.read(cachedMoodsProvider.notifier).refreshMoods(currentLang);
    }
  });
  
  ref.listen<AppLanguageProvider>(appLanguageProvider, (previous, next) {
    final previousLocale = previous?.currentLocale.languageCode;
    final currentLocale = next.currentLocale.languageCode;
    
    if (previousLocale != currentLocale) {
      final userLang = auth.user?.lang?.name ?? currentLocale;
      ref.read(cachedMoodsProvider.notifier).refreshMoods(userLang);
    }
  });
  
  return null;
});

final cachedMoodsProvider = StateNotifierProvider<CachedMoodsNotifier, List<Mood>>((ref) {
  return CachedMoodsNotifier(ref);
});

class CachedMoodsNotifier extends StateNotifier<List<Mood>> {
  final Ref ref;
  String? _currentLang;

  CachedMoodsNotifier(this.ref) : super([]);

  String? get currentLang => _currentLang;

  void setMoods(List<Mood> moods, String lang) {
    state = moods;
    _currentLang = lang;
  }

  void clearMoods() {
    state = [];
    _currentLang = null;
  }

  Future<void> refreshMoods(String lang) async {
    if (_currentLang == lang && state.isNotEmpty) {
      return;
    }
    
    final moodUseCase = ref.read(moodUseCaseProvider);
    final result = await moodUseCase.getMoods(lang);
    
    switch (result) {
      case Success(value: final moods):
        setMoods(moods, lang);
      case Failure(exception: final exception):
        devLogger('Error refreshing moods: $exception');
        clearMoods();
    }
  }
}

