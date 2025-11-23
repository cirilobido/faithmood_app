import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dev_utils/dev_utils_exports.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

class TtsService {
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isPaused = false;

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  
  void Function()? onStateChanged;

  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();
      
      _flutterTts!.setCompletionHandler(() {
        _isPlaying = false;
        _isPaused = false;
        onStateChanged?.call();
      });

      _flutterTts!.setErrorHandler((msg) {
        devLogger('TTS Error: $msg');
        _isPlaying = false;
        _isPaused = false;
        onStateChanged?.call();
      });

      _flutterTts!.setCancelHandler(() {
        _isPlaying = false;
        _isPaused = false;
        onStateChanged?.call();
      });

      _isInitialized = true;
    } catch (e) {
      devLogger('Error initializing TTS: $e');
    }
  }

  Future<bool> setLanguage(String languageCode) async {
    try {
      await _initialize();
      if (_flutterTts == null) return false;

      final languages = await _flutterTts!.getLanguages;
      final availableLanguages = languages as List<dynamic>?;

      if (availableLanguages != null && availableLanguages.isNotEmpty) {
        final language = availableLanguages.firstWhere(
          (lang) => lang.toString().startsWith(languageCode),
          orElse: () => availableLanguages.first,
        );
        await _flutterTts!.setLanguage(language.toString());
        return true;
      }

      await _flutterTts!.setLanguage(languageCode);
      return true;
    } catch (e) {
      devLogger('Error setting TTS language: $e');
      return false;
    }
  }

  Future<bool> speak(String text) async {
    try {
      await _initialize();
      if (_flutterTts == null) return false;

      if (_isPaused) {
        await _flutterTts!.speak('');
        await _flutterTts!.speak(text);
      } else {
        await _flutterTts!.speak(text);
      }

      _isPlaying = true;
      _isPaused = false;
      return true;
    } catch (e) {
      devLogger('Error speaking text: $e');
      _isPlaying = false;
      _isPaused = false;
      return false;
    }
  }

  Future<bool> pause() async {
    try {
      if (_flutterTts == null || !_isPlaying) return false;

      final result = await _flutterTts!.pause();
      if (result == 1) {
        _isPaused = true;
        _isPlaying = false;
        return true;
      }
      return false;
    } catch (e) {
      devLogger('Error pausing TTS: $e');
      return false;
    }
  }

  Future<bool> stop() async {
    try {
      if (_flutterTts == null) return false;

      final result = await _flutterTts!.stop();
      _isPlaying = false;
      _isPaused = false;
      return result == 1;
    } catch (e) {
      devLogger('Error stopping TTS: $e');
      _isPlaying = false;
      _isPaused = false;
      return false;
    }
  }

  void dispose() {
    _flutterTts?.stop();
    _flutterTts = null;
    _isInitialized = false;
    _isPlaying = false;
    _isPaused = false;
  }
}

