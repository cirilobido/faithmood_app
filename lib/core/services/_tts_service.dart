import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

class TtsService {
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  String _currentText = '';
  int _currentPosition = 0;
  int _totalLength = 0;
  int _basePositionForProgress = 0;
  bool _isSeeking = false;
  String? _selectedVoiceName;
  String? _selectedVoiceLocale;

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  int get currentPosition => _currentPosition;
  int get totalLength => _totalLength;
  double get progress => _totalLength > 0 ? _currentPosition / _totalLength : 0.0;
  String? get selectedVoiceName => _selectedVoiceName;
  String? get selectedVoiceLocale => _selectedVoiceLocale;
  
  void Function()? onStateChanged;
  void Function(double progress)? onProgressChanged;

  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();
      
      _flutterTts!.setCompletionHandler(() {
        _isPlaying = false;
        _isPaused = false;
        _currentPosition = _totalLength;
        onStateChanged?.call();
        onProgressChanged?.call(1.0);
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
        _currentPosition = 0;
        onStateChanged?.call();
        onProgressChanged?.call(0.0);
      });

      _flutterTts!.setProgressHandler((String text, int startOffset, int endOffset, String word) {
        if (_totalLength > 0 && !_isSeeking) {
          final absolutePosition = _basePositionForProgress + startOffset;
          _currentPosition = absolutePosition.clamp(0, _totalLength);
          final progressValue = _currentPosition / _totalLength;
          onProgressChanged?.call(progressValue);
        }
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

      List<dynamic> languages = await _flutterTts!.getLanguages;
      
      String languageToSet;
      if (languages.isNotEmpty) {
        final matchingLang = languages.firstWhere(
          (lang) => lang.toString().startsWith(languageCode),
          orElse: () => languages.first,
        );
        languageToSet = matchingLang.toString();
      } else {
        languageToSet = languageCode;
      }

      await _flutterTts!.setLanguage(languageToSet);
      await _setDefaultVoiceForLanguage(languageCode);
      return true;
    } catch (e) {
      devLogger('Error setting TTS language: $e');
      return false;
    }
  }

  Future<void> _setDefaultVoiceForLanguage(String languageCode) async {
    try {
      if (_flutterTts == null) return;

      final voices = await _flutterTts!.getVoices;
      if (voices == null) return;

      String targetVoiceName;
      String targetLocale;
      
      switch (languageCode) {
        case 'es':
          targetVoiceName = 'es-US-language';
          targetLocale = 'es-US';
          break;
        case 'en':
          targetVoiceName = 'en-US-language';
          targetLocale = 'en-US';
          break;
        case 'pt':
          targetVoiceName = 'pt-BR-language';
          targetLocale = 'pt-BR';
          break;
        default:
          return;
      }

      for (final voice in voices) {
        if (voice is Map) {
          final voiceName = voice['name']?.toString() ?? '';
          final locale = voice['locale']?.toString() ?? '';
          
          if (voiceName == targetVoiceName && locale == targetLocale) {
            await _flutterTts!.setVoice({
              'name': voiceName,
              'locale': locale,
            });
            
            _selectedVoiceName = voiceName;
            _selectedVoiceLocale = locale;
            return;
          }
        }
      }
    } catch (e) {
      devLogger('Error setting default voice: $e');
    }
  }

  Future<bool> speak(String text, {int? startPosition, bool skipProgressUpdate = false}) async {
    try {
      await _initialize();
      if (_flutterTts == null) return false;

      final position = startPosition ?? _currentPosition;
      String textToSpeak;
      int basePosition = 0;

      if (position > 0 && position < text.length) {
        textToSpeak = text.substring(position);
        basePosition = position;
        _currentPosition = position;
      } else {
        textToSpeak = text;
        basePosition = 0;
        _currentPosition = 0;
      }

      _currentText = text;
      _totalLength = text.length;
      _basePositionForProgress = basePosition;

      if (!skipProgressUpdate) {
        final currentProgress = _totalLength > 0 ? _currentPosition / _totalLength : 0.0;
        onProgressChanged?.call(currentProgress);
      }

      await _flutterTts!.stop();
      
      if (_selectedVoiceName != null && _selectedVoiceLocale != null) {
        await _flutterTts!.setVoice({
          'name': _selectedVoiceName!,
          'locale': _selectedVoiceLocale!,
        });
      }
      
      final result = await _flutterTts!.speak(textToSpeak);
      
      if (result == 1) {
        _isPlaying = true;
        _isPaused = false;
        onStateChanged?.call();
        return true;
      } else {
        _isPlaying = false;
        _isPaused = false;
        onStateChanged?.call();
        return false;
      }
    } catch (e) {
      devLogger('Error speaking text: $e');
      _isPlaying = false;
      _isPaused = false;
      onStateChanged?.call();
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
        onStateChanged?.call();
        return true;
      }
      
      await _flutterTts!.stop();
      _isPaused = true;
      _isPlaying = false;
      onStateChanged?.call();
      return true;
    } catch (e) {
      devLogger('Error pausing TTS: $e');
      await _flutterTts!.stop();
      _isPaused = true;
      _isPlaying = false;
      onStateChanged?.call();
      return true;
    }
  }

  Future<bool> resume() async {
    try {
      if (_flutterTts == null || !_isPaused || _currentText.isEmpty) return false;

      return await speak(_currentText, startPosition: _currentPosition);
    } catch (e) {
      devLogger('Error resuming TTS: $e');
      return false;
    }
  }

  Future<bool> stop() async {
    try {
      if (_flutterTts == null) return false;

      final result = await _flutterTts!.stop();
      
      if (result == 1) {
        _isPlaying = false;
        _isPaused = false;
        _currentPosition = 0;
        _currentText = '';
        _totalLength = 0;
        _basePositionForProgress = 0;
        onStateChanged?.call();
        onProgressChanged?.call(0.0);
        return true;
      }
      
      return false;
    } catch (e) {
      devLogger('Error stopping TTS: $e');
      _isPlaying = false;
      _isPaused = false;
      _currentPosition = 0;
      _currentText = '';
      _totalLength = 0;
      _basePositionForProgress = 0;
      onStateChanged?.call();
      onProgressChanged?.call(0.0);
      return false;
    }
  }

  Future<bool> seekToPosition(int position) async {
    bool wasPlaying = false;
    try {
      if (_flutterTts == null || _currentText.isEmpty) return false;

      _isSeeking = true;
      final clampedPosition = position.clamp(0, _currentText.length);
      wasPlaying = _isPlaying || _isPaused;

      _basePositionForProgress = clampedPosition;
      _currentPosition = clampedPosition;
      final targetProgress = _totalLength > 0 ? clampedPosition / _totalLength : 0.0;
      onProgressChanged?.call(targetProgress);

      if (wasPlaying) {
        await _flutterTts!.stop();
        await Future.delayed(const Duration(milliseconds: 200));
      }

      _isPlaying = true;
      _isPaused = false;
      onStateChanged?.call();

      final success = await speak(_currentText, startPosition: clampedPosition, skipProgressUpdate: true);
      
      if (success) {
        await Future.delayed(const Duration(milliseconds: 300));
        _isSeeking = false;
      } else {
        _isSeeking = false;
        _isPaused = wasPlaying;
        _isPlaying = false;
        onStateChanged?.call();
      }

      return success;
    } catch (e) {
      devLogger('Error seeking TTS: $e');
      _isSeeking = false;
      _isPaused = wasPlaying;
      _isPlaying = false;
      onStateChanged?.call();
      return false;
    }
  }

  Future<List<Map<String, String>>> getAvailableVoices(String languageCode) async {
    try {
      await _initialize();
      if (_flutterTts == null) return [];

      final voices = await _flutterTts!.getVoices;
      if (voices == null) return [];

      final supportedLanguages = [Lang.en.name, Lang.es.name, Lang.pt.name];
      if (!supportedLanguages.contains(languageCode)) {
        return [];
      }

      final List<Map<String, String>> allVoices = [];
      for (final voice in voices) {
        final locale = voice['locale']?.toString() ?? '';
        if (locale.startsWith(languageCode)) {
          allVoices.add({
            'name': voice['name']?.toString() ?? '',
            'locale': locale,
            'gender': _detectGender(voice['name']?.toString() ?? ''),
          });
        }
      }

      final List<Map<String, String>> filteredVoices = [];
      
      Map<String, String>? maleVoice;
      Map<String, String>? femaleVoice;
      
      for (final voice in allVoices) {
        if (voice['gender'] == 'male' && maleVoice == null) {
          maleVoice = voice;
        } else if (voice['gender'] == 'female' && femaleVoice == null) {
          femaleVoice = voice;
        }
      }

      if (femaleVoice == null) {
        try {
          femaleVoice = allVoices.firstWhere(
            (v) => (v['name'] ?? '').toLowerCase().contains('es-us-language-es-us'),
          );
        } catch (e) {
          if (allVoices.isNotEmpty) {
            femaleVoice = allVoices.first;
          }
        }
      }

      if (maleVoice == null && allVoices.length > 1) {
        for (final voice in allVoices) {
          if (voice['name'] != femaleVoice?['name'] && voice['gender'] != 'female') {
            maleVoice = voice;
            break;
          }
        }
      }

      if (femaleVoice != null && femaleVoice.isNotEmpty) {
        filteredVoices.add({
          'name': femaleVoice['name'] ?? '',
          'locale': femaleVoice['locale'] ?? '',
        });
      }
      
      if (maleVoice != null && maleVoice.isNotEmpty && maleVoice['name'] != femaleVoice?['name']) {
        filteredVoices.add({
          'name': maleVoice['name'] ?? '',
          'locale': maleVoice['locale'] ?? '',
        });
      }

      if (filteredVoices.isEmpty && allVoices.isNotEmpty) {
        filteredVoices.add({
          'name': allVoices.first['name'] ?? '',
          'locale': allVoices.first['locale'] ?? '',
        });
        if (allVoices.length > 1) {
          filteredVoices.add({
            'name': allVoices[1]['name'] ?? '',
            'locale': allVoices[1]['locale'] ?? '',
          });
        }
      }

      return filteredVoices;
    } catch (e) {
      devLogger('Error getting voices: $e');
      return [];
    }
  }

  String _detectGender(String voiceName) {
    final lowerName = voiceName.toLowerCase();
    
    final femaleKeywords = [
      'female', 'woman', 'samantha', 'susan', 'karen', 'moira', 
      'tessa', 'veena', 'zira', 'paulina', 'soledad', 'monica',
      'es-us-language-es-us',
    ];
    
    final maleKeywords = [
      'male', 'man', 'daniel', 'alex', 'thomas', 'lee', 
      'david', 'mark', 'ralph', 'jorge', 'diego', 'juan',
      'es-es-language', 'es-mx-language',
    ];

    for (final keyword in femaleKeywords) {
      if (lowerName.contains(keyword)) {
        return 'female';
      }
    }

    for (final keyword in maleKeywords) {
      if (lowerName.contains(keyword)) {
        return 'male';
      }
    }

    return 'unknown';
  }

  Future<bool> setVoice(String voiceName, String locale) async {
    try {
      await _initialize();
      if (_flutterTts == null) return false;

      await _flutterTts!.setVoice({
        'name': voiceName,
        'locale': locale,
      });

      _selectedVoiceName = voiceName;
      _selectedVoiceLocale = locale;
      
      if (_isPlaying || _isPaused) {
        final currentPos = _currentPosition;
        await _flutterTts!.stop();
        await Future.delayed(const Duration(milliseconds: 100));
        await speak(_currentText, startPosition: currentPos);
      }
      
      onStateChanged?.call();
      return true;
    } catch (e) {
      devLogger('Error setting voice: $e');
      return false;
    }
  }

  void dispose() {
    _flutterTts?.stop();
    _flutterTts = null;
    _isInitialized = false;
    _isPlaying = false;
    _isPaused = false;
    _currentText = '';
    _currentPosition = 0;
    _totalLength = 0;
    _selectedVoiceName = null;
    _selectedVoiceLocale = null;
    onStateChanged = null;
    onProgressChanged = null;
  }
}

