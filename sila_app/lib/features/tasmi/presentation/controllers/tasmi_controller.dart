
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/features/tasmi/data/models/tasmi_session_stats.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_preferences.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_entry.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_error.dart';
import 'package:sila_app/features/tasmi/data/repositories/i_tasmi_error_repository.dart';
import 'package:sila_app/features/tasmi/data/repositories/isar_tasmi_error_repository.dart';
import 'package:sila_app/features/tasmi/domain/tajweed_normalizer.dart';
import 'package:sila_app/features/tasmi/presentation/riverpod/tasmi_preferences_provider.dart';
import 'package:sila_app/features/tasmi/services/tasmi_speech_service.dart';
import 'package:sila_app/features/tasmi/services/tasmi_tts_service.dart'; // ← ADDED: TTS service import
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';

part 'tasmi_controller.g.dart';

enum TasmiStatus { idle, listening, waitingForUser, finished, error }

class TasmiState extends Equatable {
  final TasmiStatus status;
  final List<TasmiWordEntry> words;
  final int currentIndex;
  final String? correctionWord;
  final TasmiSessionStats stats;
  final String? errorMessage;
  final bool isMicListening;
  final int currentWordAttempts;

  const TasmiState({
    required this.status,
    required this.words,
    required this.currentIndex,
    this.correctionWord,
    required this.stats,
    this.errorMessage,
    required this.isMicListening,
    required this.currentWordAttempts,
  });

  factory TasmiState.initial() {
    return TasmiState(
      status: TasmiStatus.idle,
        words: [],
        currentIndex: 0,
        stats: TasmiSessionStats.initial(),
        isMicListening: false,
        currentWordAttempts: 0,
      );
  }

  TasmiState copyWith({
    TasmiStatus? status,
    List<TasmiWordEntry>? words,
    int? currentIndex,
    String? correctionWord,
    bool clearCorrectionWord = false,
    TasmiSessionStats? stats,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isMicListening,
    int? currentWordAttempts,
  }) {
    return TasmiState(
      status: status ?? this.status,
      words: words ?? this.words,
      currentIndex: currentIndex ?? this.currentIndex,
      correctionWord: clearCorrectionWord ? null : correctionWord ?? this.correctionWord,
      stats: stats ?? this.stats,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      isMicListening: isMicListening ?? this.isMicListening,
      currentWordAttempts: currentWordAttempts ?? this.currentWordAttempts,
    );
  }

  @override
  List<Object?> get props => [
        status,
        words,
        currentIndex,
        correctionWord,
        stats,
        errorMessage,
        isMicListening,
        currentWordAttempts,
      ];
}

@riverpod
class TasmiController extends _$TasmiController {
  late final TasmiSpeechService _speechService;
  StreamSubscription<String>? _speechSubscription;
  int? _surahNumber;
  bool _isProcessingWord = false;
  final List<TasmiWordError> _sessionErrors = [];

  @override
  TasmiState build() {
    _speechService = TasmiSpeechService();
    _speechService.initialize().then((available) {
      if (!available) {
        state = state.copyWith(
          status: TasmiStatus.error,
          errorMessage: 'خدمة الصوت غير متاحة. يرجى التحقق من الأذونات.',
        );
      }
    });

    ref.onDispose(() {
      _speechSubscription?.cancel();
      _speechService.dispose();
    });

    return TasmiState.initial();
  }

  Future<void> startSession({
    required int surahNumber,
    required int fromAya,
    required int toAya,
  }) async {
    _surahNumber = surahNumber;

    await _stopServicesOnly();
    _isProcessingWord = false;
    _sessionErrors.clear();

    // 1. Load verses
    final List<TasmiWordEntry> allWords = [];
    for (int i = fromAya; i <= toAya; i++) {
      String verseText = quran.getVerse(surahNumber, i, verseEndSymbol: false);
      List<String> wordsInVerse = verseText.split(' ');
      for (String word in wordsInVerse) {
        if (word.isNotEmpty) {
          allWords.add(TasmiWordEntry(verseNumber: i, word: word));
        }
      }
    }

    if (allWords.isEmpty) {
      state = state.copyWith(
        status: TasmiStatus.error,
        errorMessage: 'تعذر تحميل الآيات المحددة. يرجى المحاولة مرة أخرى.',
      );
      return;
    }

    state = state.copyWith(
      words: allWords,
      status: TasmiStatus.listening,
      currentIndex: 0,
      clearCorrectionWord: true,
      clearErrorMessage: true,
      stats: TasmiSessionStats.initial(),
      isMicListening: false,
      currentWordAttempts: 0,
    );

    // 4. Start support services
    final tts = ref.read(tasmiTtsServiceProvider);
    await tts.initialize();

    // 5. Listen to wordStream
    await _speechSubscription?.cancel(); // Cancel any previous subscription
    _speechSubscription = _speechService.wordStream.listen(
      _onWordSpoken,
      onError: (error) async {
        state = state.copyWith(
          status: TasmiStatus.error,
          errorMessage: error.toString(),
          isMicListening: false,
        );
        await _stopServicesOnly();
      },
    );

    final startedListening = await _speechService.startListening();
    if (!startedListening) {
      await _stopServicesOnly();
      state = state.copyWith(
        words: const [],
        status: TasmiStatus.error,
        currentIndex: 0,
        clearCorrectionWord: true,
        errorMessage: 'تعذر تشغيل الميكروفون. تأكد من الإذن ثم حاول مرة أخرى.',
        isMicListening: false,
        currentWordAttempts: 0,
      );
      return;
    }

    state = state.copyWith(isMicListening: true);
  }

  Future<void> _onWordSpoken(String spokenWord) async {
    if (_isProcessingWord) return;
    if (state.currentIndex >= state.words.length) return; // Session finished

    _isProcessingWord = true;
    try {

      final prefs = ref.read(tasmiPreferencesNotifierProvider);

      final currentEntry = state.words[state.currentIndex];
      final result = TajweedNormalizer.compareWord(
        spoken: spokenWord,
        expected: currentEntry.word,
        strictness: prefs.strictness,
      );

      if (result == WordMatchResult.correct) {
        _handleCorrect();
        return;
      }

      final maxAttempts = switch (prefs.attemptsMode) {
        AttemptsMode.one => 1,
        AttemptsMode.two => 2,
        AttemptsMode.three => 3,
      };

      final newAttempts = state.currentWordAttempts + 1;
      if (newAttempts < maxAttempts) {
        state = state.copyWith(currentWordAttempts: newAttempts);

        if (newAttempts == maxAttempts - 1 && prefs.ttsEnabled) {
          await _speechService.pauseForTts();
          state = state.copyWith(isMicListening: false);
          await ref.read(tasmiTtsServiceProvider).speakWord(currentEntry.word);
          await _speechService.resumeAfterTts();
          state = state.copyWith(isMicListening: true);
        }
        return;
      }

      await _handleError(spokenWord, currentEntry, result, prefs);
    } finally {
      _isProcessingWord = false;
    }
  }

  void _handleCorrect() {
    final updatedWords = List<TasmiWordEntry>.from(state.words);
    updatedWords[state.currentIndex].status = WordEntryStatus.correct;
    state = state.copyWith(
      words: updatedWords,
      currentIndex: state.currentIndex + 1,
      currentWordAttempts: 0,
      clearCorrectionWord: true,
    );

    if (state.currentIndex >= state.words.length) {
      _finish();
    }
  }

  Future<void> _handleError(
    String spokenWord,
    TasmiWordEntry entry,
    WordMatchResult result,
    TasmiPreferences prefs,
  ) async {
    final updatedWords = List<TasmiWordEntry>.from(state.words);
    updatedWords[state.currentIndex].status = result == WordMatchResult.closeError
        ? WordEntryStatus.closeError
        : WordEntryStatus.wrongWord;

    _saveError(spokenWord, entry, result);

    state = state.copyWith(
      words: updatedWords,
      currentIndex: state.currentIndex + 1,
      currentWordAttempts: 0,
      correctionWord: entry.word,
    );

    switch (prefs.onErrorBehavior) {
      case OnErrorBehavior.speakAndContinue:
        if (prefs.ttsEnabled) {
          await _speechService.pauseForTts();
          state = state.copyWith(isMicListening: false);
          await ref.read(tasmiTtsServiceProvider).speakWord(entry.word);
          await _speechService.resumeAfterTts();
          state = state.copyWith(isMicListening: true);
        }
        await Future.delayed(const Duration(seconds: 1));
        state = state.copyWith(clearCorrectionWord: true);
        break;
      case OnErrorBehavior.waitForUser:
        if (prefs.ttsEnabled) {
          await _speechService.pauseForTts();
          state = state.copyWith(isMicListening: false);
          await ref.read(tasmiTtsServiceProvider).speakWord(entry.word);
        } else {
          await _speechService.pauseForTts();
          state = state.copyWith(isMicListening: false);
        }
        state = state.copyWith(status: TasmiStatus.waitingForUser);
        break;
      case OnErrorBehavior.continueOnly:
        await Future.delayed(const Duration(milliseconds: 800));
        state = state.copyWith(clearCorrectionWord: true);
        break;
    }

    if (state.currentIndex >= state.words.length) {
      _finish();
    }
  }

  Future<void> resumeAfterUserPrompt() async {
    if (state.status != TasmiStatus.waitingForUser) return;
    state = state.copyWith(status: TasmiStatus.listening, clearCorrectionWord: true);
    await _speechService.resumeAfterTts();
    state = state.copyWith(isMicListening: true);

    if (state.currentIndex >= state.words.length) {
      _finish();
    }
  }

  void _saveError(String spokenWord, TasmiWordEntry entry, WordMatchResult result) {
    final errorModel = TasmiWordError()
      ..surahIndex = _surahNumber!
      ..verseNumber = entry.verseNumber
      ..correctWord = entry.word
      ..spokenWord = spokenWord
      ..errorTypeIndex = result.index
      ..timestamp = DateTime.now();

    _sessionErrors.add(errorModel);

    final repoAsync = ref.read(tasmiErrorRepositoryProvider);
    repoAsync.whenData((repo) {
      repo.saveError(errorModel);
    });
  }

  void stopSession() {
    if (state.status == TasmiStatus.listening) {
      _finish(); // Also calculate stats if stopped manually
      return;
    }

    unawaited(_stopServicesOnly());
  }

  void _finish() {
    _isProcessingWord = false;
    _speechService.stopListening();
    _speechSubscription?.cancel();
    ref.read(tasmiTtsServiceProvider).stop(); // ← ADDED: TTS stop

    int correct = 0;
    int close = 0;
    int wrong = 0;
    int skipped = 0;

    for (final entry in state.words) {
      switch (entry.status) {
        case WordEntryStatus.correct:
          correct++;
          break;
        case WordEntryStatus.closeError:
          close++;
          break;
        case WordEntryStatus.wrongWord:
          wrong++;
          break;
        case WordEntryStatus.skipped:
          skipped++;
          break;
        case WordEntryStatus.hidden:
          break;
      }
    }

    state = state.copyWith(
      status: TasmiStatus.finished,
      isMicListening: false,
      stats: TasmiSessionStats(
        correctCount: correct,
        closeErrorCount: close,
        wrongCount: wrong,
        skippedCount: skipped,
        errorList: List<TasmiWordError>.from(_sessionErrors),
      ),
    );
  }

  Future<void> _stopServicesOnly() async {
    await _speechService.stopListening();
    await _speechSubscription?.cancel();
    _speechSubscription = null;
    ref.read(tasmiTtsServiceProvider).stop();
    state = state.copyWith(isMicListening: false);
  }
}

final tasmiErrorRepositoryProvider = FutureProvider<ITasmiErrorRepository>((ref) async {
  try {
    final isar = await ref.watch(isarInstanceProvider.future);
    return IsarTasmiErrorRepository(isar);
  } catch (_) {
    return _NoOpTasmiErrorRepository();
  }
});

// Fallback no-op repository used while Isar is loading
class _NoOpTasmiErrorRepository implements ITasmiErrorRepository {
  @override
  Future<void> saveError(TasmiWordError error) async {}
  @override
  Future<List<TasmiWordError>> getAll() async => [];
  @override
  Future<List<TasmiWordError>> getBySurah(int surahIndex) async => [];
  @override
  Future<void> clearAll() async {}
}
