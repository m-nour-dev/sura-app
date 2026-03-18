import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasmi_tts_service.g.dart';

class TasmiTtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _isSpeaking = false;
  Timer? _debounceTimer;

  bool get isSpeaking => _isSpeaking;

  Future<void> initialize() async {
    if (_initialized) return;

    await _tts.setLanguage('ar-SA');
    await _tts.setSpeechRate(0.40); // slightly slower for clearer Arabic
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // Prevents the internal native Android service from deadlocking Dart if interrupted
    await _tts.awaitSpeakCompletion(false);

    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      debugPrint('TTS Error: $msg');
    });

    final voices = await _tts.getVoices;
    final arabicVoices = (voices as List)
        .where((v) => v['locale']?.toString().startsWith('ar') == true)
        .toList();

    debugPrint('🔊 Arabic voices found: ${arabicVoices.length}');

    if (arabicVoices.isNotEmpty) {
      await _tts.setVoice({
        'name': arabicVoices.first['name'],
        'locale': arabicVoices.first['locale'],
      });
    }

    _initialized = true;
    debugPrint('✅ TasmiTtsService ready');
  }

  void speakWord(String word) {
    if (!_initialized) return;

    // Debounce rapid requests to prevent overlap and Android audio channel locking
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 150), () async {
      try {
        if (_isSpeaking) {
          await _tts.stop(); // Safe guard to clear channel
          _isSpeaking = false;
        }
        
        debugPrint('🔊 Speaking: "$word"');
        _tts.speak(word).catchError((e) {
          debugPrint('TTS Engine Exception: $e');
          _isSpeaking = false;
        });
      } catch (e) {
        debugPrint('TTS Global Error: $e');
        _isSpeaking = false;
      }
    });
  }

  void stop() {
    _debounceTimer?.cancel();
    _isSpeaking = false;
    _tts.stop();
  }

  void dispose() {
    _debounceTimer?.cancel();
    _tts.stop();
  }
}

@riverpod
TasmiTtsService tasmiTtsService(TasmiTtsServiceRef ref) {
  final service = TasmiTtsService();
  ref.onDispose(() => service.dispose());
  return service;
}
