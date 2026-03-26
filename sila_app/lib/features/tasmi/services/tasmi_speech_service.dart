import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum MicHealthStatus { active, reconnecting, stalled }

class TasmiSpeechService {
  factory TasmiSpeechService() => _instance ??= TasmiSpeechService._internal();
  TasmiSpeechService._internal();
  static TasmiSpeechService? _instance;

  final stt.SpeechToText _speech = stt.SpeechToText();
  final _wordController = StreamController<String>.broadcast();
  final _textController = StreamController<String>.broadcast();
  final _micHealthController = StreamController<MicHealthStatus>.broadcast();

  String _lastRecognizedWords = '';
  bool _isManuallyStopped = false;
  bool _isRestarting = false;
  bool _isPausedForTts = false;
  bool _autoRestartEnabled = true;
  Timer? _restartTimer;
  Timer? _watchdogTimer;
  DateTime? _lastWordReceivedAt;
  bool _isWatchdogHealing = false;
  bool _disposed = false;

  static const _watchdogInterval = Duration(seconds: 8);
  static const _silenceThreshold = Duration(seconds: 8);

  Stream<String> get wordStream => _wordController.stream;
  Stream<String> get textStream => _textController.stream;
  Stream<MicHealthStatus> get micHealthStream => _micHealthController.stream;

  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    if (_disposed) {
      debugPrint('TasmiSpeechService: Cannot initialize after disposal');
      return false;
    }
    
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
    if (_disposed) {
      debugPrint('TasmiSpeechService: Cannot start listening after disposal');
      return false;
    }
    
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
    _startWatchdog();
    final started = await _startInternal();
    if (started && !_micHealthController.isClosed) {
      _micHealthController.add(MicHealthStatus.active);
    } else if (!started && !_micHealthController.isClosed) {
      _micHealthController.add(MicHealthStatus.stalled);
    }
    return started;
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
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    await _speech.stop();
  }

  Future<void> pauseForTts() async {
    _restartTimer?.cancel();
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
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
    final started = await _startInternal();
    if (started) {
      _startWatchdog();
      if (!_micHealthController.isClosed) {
        _micHealthController.add(MicHealthStatus.active);
      }
    } else if (!_micHealthController.isClosed) {
      _micHealthController.add(MicHealthStatus.stalled);
    }
    debugPrint('STT resumed after TTS');
  }

  void _onResult(SpeechRecognitionResult result) {
    if (_wordController.isClosed) return;

    _lastWordReceivedAt = DateTime.now();

    final currentWords = result.recognizedWords.trim();
    if (currentWords.isEmpty) return;

    if (!_micHealthController.isClosed) {
      _micHealthController.add(MicHealthStatus.active);
    }

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
    if (error.errorMsg != 'error_client' && error.errorMsg != 'error_speech_timeout' && error.errorMsg != 'error_no_match') {
      debugPrint('STT Error: ${error.errorMsg}, permanent: ${error.permanent}');
    }

    if (!_autoRestartEnabled && error.errorMsg == 'error_network' && !_wordController.isClosed) {
      _wordController.addError('يرجى التحقق من الاتصال بالإنترنت');
    }

    if (error.errorMsg == 'error_no_match' && !_wordController.isClosed) {
      _wordController.addError('error_mic_final');
    }

    if (!_autoRestartEnabled) {
      if (error.permanent && error.errorMsg == 'error_permission' && !_wordController.isClosed) {
        _wordController.addError('يرجى السماح بصلاحية الميكروفون');
      }
      return;
    }

    if (error.errorMsg == 'error_client') {
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

  void _startWatchdog() {
    _watchdogTimer?.cancel();
    _lastWordReceivedAt = DateTime.now();
    _watchdogTimer = Timer.periodic(
      _watchdogInterval,
      (_) async {
        // Don't await here to prevent blocking the timer, but check guard before starting
        if (!_isWatchdogHealing) {
          unawaited(_checkAndHeal());
        }
      },
    );
  }

  Future<void> _checkAndHeal() async {
    if (_isWatchdogHealing) {
      return;
    }

    if (_isManuallyStopped || _isPausedForTts || _wordController.isClosed) {
      return;
    }

    _isWatchdogHealing = true;

    try {
      final sinceLastWord = _lastWordReceivedAt == null
          ? _silenceThreshold
          : DateTime.now().difference(_lastWordReceivedAt!);

      final isActuallyListening = _speech.isListening;
      final silenceTooLong = sinceLastWord >= _silenceThreshold;

      if (!isActuallyListening || silenceTooLong) {
        debugPrint(
          '🔧 Watchdog: healing STT — '
          'isListening=$isActuallyListening '
          'silence=${sinceLastWord.inSeconds}s',
        );

        if (!_micHealthController.isClosed) {
          _micHealthController.add(MicHealthStatus.reconnecting);
        }

        final healed = await _hardReset();
        if (!_micHealthController.isClosed) {
          _micHealthController.add(
            healed ? MicHealthStatus.active : MicHealthStatus.stalled,
          );
        }
      }
    } finally {
      _isWatchdogHealing = false;
    }
  }

  Future<bool> _hardReset() async {
    _restartTimer?.cancel();
    _isRestarting = false;

    try {
      // Use cancel() to discard any in-progress recognition results
      // since we're doing a hard reset and don't need to finalize anything
      await _speech.cancel();
      await Future.delayed(const Duration(milliseconds: 400));
    } catch (e, st) {
      debugPrint('tasmi_speech_service _hardReset failed during cancel: $e\n$st');
    }

    if (!_isManuallyStopped && !_isPausedForTts && !_wordController.isClosed) {
      _lastRecognizedWords = '';
      _lastWordReceivedAt = DateTime.now();
      final restarted = await _startInternal();
      if (restarted) {
        debugPrint('🔧 Watchdog: STT restarted');
      }
      return restarted;
    }

    return false;
  }

  Future<void> forceRestart() async {
    debugPrint('🔧 Manual restart requested');
    _lastWordReceivedAt = null;
    if (!_micHealthController.isClosed) {
      _micHealthController.add(MicHealthStatus.reconnecting);
    }
    final restarted = await _hardReset();
    if (!_micHealthController.isClosed) {
      _micHealthController.add(
        restarted ? MicHealthStatus.active : MicHealthStatus.stalled,
      );
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }
    
    _restartTimer?.cancel();
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    _isWatchdogHealing = false;
    _speech.cancel();
    
    if (!_wordController.isClosed) {
      _wordController.close();
    }
    if (!_textController.isClosed) {
      _textController.close();
    }
    if (!_micHealthController.isClosed) {
      _micHealthController.close();
    }
    
    _disposed = true;
    _instance = null;
  }
}
