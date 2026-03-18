
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class TasmiSpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final _wordController = StreamController<String>.broadcast();
  
  // Keep track of the last recognized words to avoid duplicates if needed,
  // though the requirement says "Extract only the last NEW word".
  String _lastRecognizedWords = '';

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

    _lastRecognizedWords = '';
    
    await _speech.listen(
      onResult: _onResult,
      localeId: 'ar_SA',
      listenMode: stt.ListenMode.dictation,
      pauseFor: const Duration(seconds: 3),
      cancelOnError: false,
      partialResults: true,
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  void _onResult(SpeechRecognitionResult result) {
    if (result.recognizedWords.isNotEmpty) {
      String currentWords = result.recognizedWords;
      
      // The speech_to_text package returns the full sentence so far.
      // We need to extract only the newly added part.
      
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
    // You might want to expose status updates via another stream if needed
  }

  void _onError(SpeechRecognitionError error) {
    // Handle specific error cases
    String errorMessage = 'حدث خطأ في التعرف على الصوت';
    
    if (error.errorMsg == 'error_permission') {
      errorMessage = 'يرجى السماح بصلاحية الميكروفون لاستخدام هذه الميزة';
    } else if (error.errorMsg == 'error_network') {
      errorMessage = 'يرجى التحقق من الاتصال بالإنترنت';
    }
    
    // Only add error if it's a permanent failure, otherwise just log
    if (error.permanent) {
       _wordController.addError(errorMessage);
    }
  }

  void dispose() {
    _speech.cancel();
    _wordController.close();
  }
}
