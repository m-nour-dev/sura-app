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
  Completer<void>? _speakCompleter;

  bool get isSpeaking => _isSpeaking;

  Future<void> initialize() async {
    if (_initialized) return;

    await _tts.setLanguage('ar-SA');
    await _tts.setSpeechRate(0.40); // slightly slower for clearer Arabic
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // Prevents the internal native Android service from deadlocking Dart if interrupted
    await _tts.awaitSpeakCompletion(true);

    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
        _speakCompleter!.complete();
      }
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
      if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
        _speakCompleter!.complete();
      }
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      debugPrint('TTS Error: $msg');
      if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
        _speakCompleter!.completeError(Exception(msg));
      }
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

  Future<void> speakWord(String word) async {
    if (!_initialized) return;

    // Debounce rapid requests to prevent overlap and Android audio channel locking
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _speakCompleter = Completer<void>();

    _debounceTimer = Timer(const Duration(milliseconds: 150), () async {
      try {
        if (_isSpeaking) {
          await _tts.stop(); // Safe guard to clear channel
          _isSpeaking = false;
        }

        debugPrint('🔊 Speaking: "$word"');
        await _tts.speak(word);
        if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
          _speakCompleter!.complete();
        }
      } catch (e) {
        debugPrint('TTS Global Error: $e');
        _isSpeaking = false;
        if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
          _speakCompleter!.completeError(e);
        }
      }
    });

    return _speakCompleter!.future;
  }

  void stop() {
    _debounceTimer?.cancel();
    _isSpeaking = false;
    if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
      _speakCompleter!.complete();
    }
    _tts.stop();
  }

  void dispose() {
    _debounceTimer?.cancel();
    if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
      _speakCompleter!.complete();
    }
    _tts.stop();
  }
}

@riverpod
TasmiTtsService tasmiTtsService(TasmiTtsServiceRef ref) {
  final service = TasmiTtsService();
  ref.onDispose(service.dispose);
  return service;
}
