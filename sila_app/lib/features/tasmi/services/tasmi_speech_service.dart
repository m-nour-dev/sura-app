import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class TasmiSpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final _wordController = StreamController<String>.broadcast();
  
  String _lastRecognizedWords = '';
  bool _isManuallyStopped = false;

  Stream<String> get wordStream => _wordController.stream;

  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('Microphone permission denied');
        return false;
      }

      bool available = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
      );
      return available;
    } catch (e) {
      print('Speech initialization error: $e');
      return false;
    }
  }

  Future<void> startListening() async {
    if (!_speech.isAvailable) {
      bool available = await initialize();
      if (!available) {
        _wordController.addError('خدمة التعرف على الصوت غير متاحة');
        return;
      }
    }

    _isManuallyStopped = false;
    _startInternal();
  }

  Future<void> _startInternal() async {
    if (_isManuallyStopped) return;
    
    _lastRecognizedWords = '';
    
    try {
      await _speech.listen(
        onResult: _onResult,
        localeId: 'ar_SA',
        listenMode: stt.ListenMode.dictation,
        pauseFor: const Duration(seconds: 10), // Give users more time to breathe between Ayahs
        cancelOnError: false,
        partialResults: true,
      );
    } catch (e) {
      print('Speech listen error: $e');
    }
  }

  Future<void> stopListening() async {
    _isManuallyStopped = true;
    await _speech.stop();
  }

  void _onResult(SpeechRecognitionResult result) {
    if (result.recognizedWords.isNotEmpty) {
      String currentWords = result.recognizedWords;
      
      // If the speech engine restarts internally, currentWords will be shorter.
      // We must reset our tracked substring logic.
      if (currentWords.length < _lastRecognizedWords.length) {
        _lastRecognizedWords = '';
      }
      
      if (currentWords.length > _lastRecognizedWords.length) {
        // Extract the new part
        String newPart = currentWords.substring(_lastRecognizedWords.length).trim();
        
        if (newPart.isNotEmpty) {
          // Split by spaces to handle multiple words spoken quickly
          List<String> newWords = newPart.split(RegExp(r'\s+'));
          
          for (String word in newWords) {
            if (word.isNotEmpty) {
              _wordController.add(word);
            }
          }
        }
        
        _lastRecognizedWords = currentWords;
      }
    }
  }

  void _onStatus(String status) {
    // print('Speech status: $status');
    // If the engine stops listening because it timed out (user breathed), autorestart!
    if (status == 'done' || status == 'notListening') {
      if (!_isManuallyStopped) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!_isManuallyStopped && !_speech.isListening) {
             _startInternal();
          }
        });
      }
    }
  }

  void _onError(SpeechRecognitionError error) {
    String errorMessage = 'حدث خطأ في التعرف على الصوت';
    
    if (error.errorMsg == 'error_permission') {
      errorMessage = 'يرجى السماح بصلاحية الميكروفون لاستخدام هذه الميزة';
    } else if (error.errorMsg == 'error_network') {
      errorMessage = 'يرجى التحقق من الاتصال بالإنترنت';
    }
    
    if (error.permanent) {
       _wordController.addError(errorMessage);
    }
  }

  void dispose() {
    _speech.cancel();
    _wordController.close();
  }
}
