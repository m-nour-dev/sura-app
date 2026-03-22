import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class TasmiSpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final _wordController = StreamController<String>.broadcast();
  final _textController = StreamController<String>.broadcast();

  String _lastRecognizedWords = '';
  bool _isManuallyStopped = false;
  bool _isRestarting = false;
  bool _isPausedForTts = false;
  bool _autoRestartEnabled = true;
  Timer? _restartTimer;

  Stream<String> get wordStream => _wordController.stream;
  Stream<String> get textStream => _textController.stream;

  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        debugPrint('Microphone permission denied');
        return false;
      }

      final available = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
      );
      return available;
    } catch (e) {
      debugPrint('Speech initialization error: $e');
      return false;
    }
  }

  Future<bool> startListening({bool autoRestart = true}) async {
    if (!_speech.isAvailable) {
      final available = await initialize();
      if (!available) {
        _wordController.addError('خدمة التعرف على الصوت غير متاحة');
        return false;
      }
    }

    _isManuallyStopped = false;
    _isRestarting = false;
    _autoRestartEnabled = autoRestart;
    _restartTimer?.cancel();
    return _startInternal();
  }

  Future<bool> _startInternal() async {
    if (_isManuallyStopped || _wordController.isClosed) return false;
    if (_speech.isListening) return true;

    _lastRecognizedWords = '';

    try {
      await _speech.listen(
        onResult: _onResult,
        localeId: 'ar-SA',
        listenMode: stt.ListenMode.dictation,
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 3),
        cancelOnError: false,
        partialResults: true,
      );
      return true;
    } catch (e) {
      debugPrint('Speech listen error: $e');
      _wordController.addError('تعذر بدء الاستماع. حاول مرة أخرى.');
      return false;
    }
  }

  Future<void> stopListening() async {
    _isManuallyStopped = true;
    _isRestarting = false;
    _restartTimer?.cancel();
    await _speech.stop();
  }

  Future<void> pauseForTts() async {
    _restartTimer?.cancel();
    _isRestarting = false;
    _isPausedForTts = true;
    if (_speech.isListening) {
      await _speech.stop();
    }
    debugPrint('STT paused for TTS');
  }

  Future<void> resumeAfterTts() async {
    if (_isManuallyStopped || _wordController.isClosed) return;
    _isPausedForTts = false;
    await Future.delayed(const Duration(milliseconds: 500));
    await _startInternal();
    debugPrint('STT resumed after TTS');
  }

  void _onResult(SpeechRecognitionResult result) {
    if (_wordController.isClosed) return;

    final currentWords = result.recognizedWords.trim();
    if (currentWords.isEmpty) return;

    if (!_textController.isClosed) {
      _textController.add(currentWords);
    }

    final firstTrackedToken = _lastRecognizedWords.isNotEmpty
        ? _lastRecognizedWords.split(' ').first
        : '';

    if (currentWords.length < _lastRecognizedWords.length ||
        !currentWords.startsWith(firstTrackedToken)) {
      _lastRecognizedWords = '';
    }

    if (currentWords.length > _lastRecognizedWords.length) {
      final newPart = currentWords.substring(_lastRecognizedWords.length).trim();

      if (newPart.isNotEmpty) {
        final newWords = newPart
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .toList();

        for (final word in newWords) {
          _wordController.add(word);
        }
      }

      _lastRecognizedWords = currentWords;
    }
  }

  void _onStatus(String status) {
    debugPrint('STT Status: $status');
    if (_autoRestartEnabled && (status == 'done' || status == 'notListening')) {
      _isRestarting = false;
      _scheduleRestart();
    }
  }

  void _onError(SpeechRecognitionError error) {
    debugPrint('STT Error: ${error.errorMsg}, permanent: ${error.permanent}');

    if (error.errorMsg == 'error_network' && !_wordController.isClosed) {
      _wordController.addError('يرجى التحقق من الاتصال بالإنترنت');
    }

    if (error.errorMsg == 'error_no_match' && !_wordController.isClosed) {
      _wordController.addError('لم يتم التقاط التلاوة. حاول التحدث بوضوح.');
    }

    if (!_autoRestartEnabled) {
      if (error.permanent && error.errorMsg == 'error_permission' && !_wordController.isClosed) {
        _wordController.addError('يرجى السماح بصلاحية الميكروفون');
      }
      return;
    }

    if (error.errorMsg == 'error_client') {
      debugPrint('⚠️ error_client — treating as temporary, retrying in 1500ms');
      _scheduleRestart(delay: const Duration(milliseconds: 1500));
      return;
    }

    if (error.permanent && error.errorMsg == 'error_permission') {
      if (!_wordController.isClosed) {
        _wordController.addError('يرجى السماح بصلاحية الميكروفون');
      }
      return;
    }

    switch (error.errorMsg) {
      case 'error_speech_timeout':
      case 'error_no_match':
        _scheduleRestart(delay: const Duration(milliseconds: 300));
        break;
      case 'error_busy':
        _scheduleRestart(delay: const Duration(milliseconds: 1200));
        break;
      case 'error_network':
        if (!_wordController.isClosed) {
          _wordController.addError('يرجى التحقق من الاتصال بالإنترنت');
        }
        break;
      default:
        _scheduleRestart(delay: const Duration(milliseconds: 1000));
    }
  }

  void _scheduleRestart({Duration delay = const Duration(milliseconds: 350)}) {
    if (_isManuallyStopped ||
        _isPausedForTts ||
        _isRestarting ||
        !_autoRestartEnabled ||
        _wordController.isClosed) {
      return;
    }

    _isRestarting = true;
    _restartTimer?.cancel();
    _restartTimer = Timer(delay, () async {
      if (!_isManuallyStopped && !_speech.isListening) {
        await _startInternal();
      }
      _isRestarting = false;
    });
  }

  void dispose() {
    _restartTimer?.cancel();
    _speech.cancel();
    _textController.close();
    _wordController.close();
  }
}
