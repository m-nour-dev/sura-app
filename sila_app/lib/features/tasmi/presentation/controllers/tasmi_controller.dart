
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/features/tasmi/data/models/tasmi_session_stats.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_entry.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_error.dart';
import 'package:sila_app/features/tasmi/data/repositories/i_tasmi_error_repository.dart';
import 'package:sila_app/features/tasmi/data/repositories/isar_tasmi_error_repository.dart';
import 'package:sila_app/features/tasmi/domain/tajweed_normalizer.dart';
import 'package:sila_app/features/tasmi/services/tasmi_speech_service.dart';
import 'package:sila_app/features/tasmi/services/tasmi_tts_service.dart'; // ← ADDED: TTS service import
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';

part 'tasmi_controller.g.dart';

enum TasmiStatus { idle, listening, finished, error }

class TasmiState extends Equatable {
  final TasmiStatus status;
  final List<TasmiWordEntry> words;
  final int currentIndex;
  final String? correctionWord;
  final TasmiSessionStats stats;
  final String? errorMessage;

  const TasmiState({
    required this.status,
    required this.words,
    required this.currentIndex,
    this.correctionWord,
    required this.stats,
    this.errorMessage,
  });

  factory TasmiState.initial() {
    return TasmiState(
      status: TasmiStatus.idle,
      words: [],
      currentIndex: 0,
      stats: TasmiSessionStats.initial(),
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
  }) {
    return TasmiState(
      status: status ?? this.status,
      words: words ?? this.words,
      currentIndex: currentIndex ?? this.currentIndex,
      correctionWord: clearCorrectionWord ? null : correctionWord ?? this.correctionWord,
      stats: stats ?? this.stats,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
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
      ];
}

@riverpod
class TasmiController extends _$TasmiController {
  late final TasmiSpeechService _speechService;
  StreamSubscription<String>? _speechSubscription;
  int? _surahNumber;

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

    state = state.copyWith(
      words: allWords,
      status: TasmiStatus.listening,
      currentIndex: 0,
      clearCorrectionWord: true,
      clearErrorMessage: true,
    );

    // 4. Start speech service
    await _speechService.startListening();

    // ← ADDED: TTS init
    final tts = ref.read(tasmiTtsServiceProvider);
    await tts.initialize();

    // 5. Listen to wordStream
    _speechSubscription?.cancel(); // Cancel any previous subscription
    _speechSubscription = _speechService.wordStream.listen(
      _onWordSpoken,
      onError: (error) {
        state = state.copyWith(status: TasmiStatus.error, errorMessage: error.toString());
        stopSession();
      },
    );
  }

  Future<void> _onWordSpoken(String spokenWord) async {
    if (state.currentIndex >= state.words.length) return; // Session finished

    final currentEntry = state.words[state.currentIndex];
    final result = TajweedNormalizer.compareWord(
      spoken: spokenWord,
      expected: currentEntry.word,
    );

    final updatedWords = List<TasmiWordEntry>.from(state.words);
    String? newCorrectionWord;

    if (result == WordMatchResult.correct) {
      updatedWords[state.currentIndex].status = WordEntryStatus.correct;
    } else {
      // It's an error (close or wrong)
      updatedWords[state.currentIndex].status = result == WordMatchResult.closeError
          ? WordEntryStatus.closeError
          : WordEntryStatus.wrongWord;

      newCorrectionWord = currentEntry.word;
      // ← ADDED: TTS speak correct word
      ref.read(tasmiTtsServiceProvider).speakWord(currentEntry.word);

      // Save error to repository
      final repoAsync = ref.read(tasmiErrorRepositoryProvider);
      repoAsync.when(
        data: (repo) {
          final errorModel = TasmiWordError()
            ..surahIndex = _surahNumber!
            ..verseNumber = currentEntry.verseNumber
            ..correctWord = currentEntry.word
            ..spokenWord = spokenWord
            ..errorTypeIndex = result.index
            ..timestamp = DateTime.now();
          repo.saveError(errorModel);
        },
        loading: () {},
        error: (_, __) {},
      );

      // Schedule correction bubble to disappear
      Future.delayed(const Duration(seconds: 2), () {
        if (state.correctionWord == newCorrectionWord) {
          state = state.copyWith(clearCorrectionWord: true);
        }
      });
    }

    state = state.copyWith(
      words: updatedWords,
      currentIndex: state.currentIndex + 1,
      correctionWord: newCorrectionWord,
      clearCorrectionWord: newCorrectionWord == null,
    );

    if (state.currentIndex >= state.words.length) {
      _finish();
    }
  }

  void stopSession() {
    _speechService.stopListening();
    _speechSubscription?.cancel();
    ref.read(tasmiTtsServiceProvider).stop(); // ← ADDED: TTS stop
    if (state.status != TasmiStatus.finished) {
      _finish(); // Also calculate stats if stopped manually
    }
  }

  void _finish() {
    _speechService.stopListening();
    _speechSubscription?.cancel();
    ref.read(tasmiTtsServiceProvider).stop(); // ← ADDED: TTS stop

    int correctCount = 0;
    int errorCount = 0;
    final List<TasmiWordError> errors = []; // This should be populated from the repo or during session

    for (var entry in state.words) {
      if (entry.status == WordEntryStatus.correct) {
        correctCount++;
      } else if (entry.status == WordEntryStatus.closeError ||
          entry.status == WordEntryStatus.wrongWord) {
        errorCount++;
        // We would need to have stored the spoken word to create a full TasmiWordError here
      }
    }

    final finalStats = TasmiSessionStats(
      correctCount: correctCount,
      errorCount: errorCount,
      errors: errors, // This is simplified. A real implementation would fetch from the repo.
    );

    state = state.copyWith(status: TasmiStatus.finished, stats: finalStats);
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
