import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/features/hifz/data/models/hifz_moment.dart';
import 'package:sila_app/features/hifz/data/models/hifz_session.dart';
import 'package:sila_app/features/hifz/data/models/hifz_verse_record.dart';
import 'package:sila_app/features/hifz/data/repositories/hifz_repository_provider.dart';
import 'package:sila_app/features/hifz/domain/hasanat_calculator.dart';
import 'package:sila_app/features/hifz/domain/spaced_repetition_engine.dart';
import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';
import 'package:sila_app/features/quran/presentation/riverpod/audio_controller.dart';
import 'package:sila_app/features/tasmi/domain/tajweed_normalizer.dart';
import 'package:sila_app/features/tasmi/services/tasmi_speech_service.dart';

part 'interactive_shadow_controller.g.dart';

class ShadowWordEntry {
  final String word;
  final bool isAyahMarker;
  final bool isHidden;
  final bool revealedCorrectly;

  const ShadowWordEntry({
    required this.word,
    required this.isAyahMarker,
    required this.isHidden,
    required this.revealedCorrectly,
  });

  ShadowWordEntry copyWith({
    String? word,
    bool? isAyahMarker,
    bool? isHidden,
    bool? revealedCorrectly,
  }) {
    return ShadowWordEntry(
      word: word ?? this.word,
      isAyahMarker: isAyahMarker ?? this.isAyahMarker,
      isHidden: isHidden ?? this.isHidden,
      revealedCorrectly: revealedCorrectly ?? this.revealedCorrectly,
    );
  }
}

class StageResult {
  final int totalWords;
  final int correctWords;
  final int wrongWords;

  const StageResult({
    required this.totalWords,
    required this.correctWords,
    required this.wrongWords,
  });
}

class InteractiveShadowState {
  final int surahNumber;
  final int fromVerse;
  final int toVerse;
  final int currentVerseIndex;
  final int currentStage;
  final List<ShadowWordEntry> words;
  final bool isPlaying;
  final bool isMicListening;
  final int sessionHashanat;
  final Map<int, StageResult> stageResults;
  final int correctWords;
  final int wrongWords;
  final bool showMomentPrompt;
  final bool finished;
  final double accuracy;
  final String? errorMessage;
  final String reflectionText;

  const InteractiveShadowState({
    required this.surahNumber,
    required this.fromVerse,
    required this.toVerse,
    required this.currentVerseIndex,
    required this.currentStage,
    required this.words,
    required this.isPlaying,
    required this.isMicListening,
    required this.sessionHashanat,
    required this.stageResults,
    required this.correctWords,
    required this.wrongWords,
    required this.showMomentPrompt,
    required this.finished,
    required this.accuracy,
    required this.errorMessage,
    required this.reflectionText,
  });

  factory InteractiveShadowState.initial() {
    return const InteractiveShadowState(
      surahNumber: 1,
      fromVerse: 1,
      toVerse: 5,
      currentVerseIndex: 0,
      currentStage: 1,
      words: [],
      isPlaying: false,
      isMicListening: false,
      sessionHashanat: 0,
      stageResults: {},
      correctWords: 0,
      wrongWords: 0,
      showMomentPrompt: false,
      finished: false,
      accuracy: 0,
      errorMessage: null,
      reflectionText: '',
    );
  }

  InteractiveShadowState copyWith({
    int? surahNumber,
    int? fromVerse,
    int? toVerse,
    int? currentVerseIndex,
    int? currentStage,
    List<ShadowWordEntry>? words,
    bool? isPlaying,
    bool? isMicListening,
    int? sessionHashanat,
    Map<int, StageResult>? stageResults,
    int? correctWords,
    int? wrongWords,
    bool? showMomentPrompt,
    bool? finished,
    double? accuracy,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? reflectionText,
  }) {
    return InteractiveShadowState(
      surahNumber: surahNumber ?? this.surahNumber,
      fromVerse: fromVerse ?? this.fromVerse,
      toVerse: toVerse ?? this.toVerse,
      currentVerseIndex: currentVerseIndex ?? this.currentVerseIndex,
      currentStage: currentStage ?? this.currentStage,
      words: words ?? this.words,
      isPlaying: isPlaying ?? this.isPlaying,
      isMicListening: isMicListening ?? this.isMicListening,
      sessionHashanat: sessionHashanat ?? this.sessionHashanat,
      stageResults: stageResults ?? this.stageResults,
      correctWords: correctWords ?? this.correctWords,
      wrongWords: wrongWords ?? this.wrongWords,
      showMomentPrompt: showMomentPrompt ?? this.showMomentPrompt,
      finished: finished ?? this.finished,
      accuracy: accuracy ?? this.accuracy,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      reflectionText: reflectionText ?? this.reflectionText,
    );
  }
}

@riverpod
class InteractiveShadowController extends _$InteractiveShadowController {
  TasmiSpeechService? _speechService;
  StreamSubscription<String>? _speechSubscription;
  final List<HifzSession> _sessionRows = [];
  final List<int> _alreadyHidden = [];
  int _stageCorrect = 0;
  int _stageWrong = 0;
  DateTime? _stageStartedAt;

  @override
  InteractiveShadowState build() {
    ref.onDispose(() async {
      await _speechSubscription?.cancel();
      _speechService?.dispose();
    });
    return InteractiveShadowState.initial();
  }

  Future<void> startSession({
    required int surahNumber,
    required int fromVerse,
    required int toVerse,
  }) async {
    unawaited(
      ref.read(analyticsServiceProvider).logHifzSessionStart(
            surahName: quran.getSurahNameArabic(surahNumber),
            method: 'interactive_shadow',
          ).catchError((_) {}),
    );

    state = state.copyWith(
      surahNumber: surahNumber,
      fromVerse: fromVerse,
      toVerse: toVerse,
      currentVerseIndex: 0,
      currentStage: 1,
      sessionHashanat: 0,
      stageResults: {},
      correctWords: 0,
      wrongWords: 0,
      showMomentPrompt: false,
      finished: false,
      accuracy: 0,
      clearErrorMessage: true,
    );
    _sessionRows.clear();
    _alreadyHidden.clear();
    await _loadCurrentVerseWords();
    await _runCurrentStage();
  }

  Future<void> nextStageOrVerse() async {
    _captureStageStats();
    if (state.currentStage < 5) {
      state = state.copyWith(currentStage: state.currentStage + 1);
      await _applyHidingForStage();
      await _runCurrentStage();
      return;
    }
    state = state.copyWith(showMomentPrompt: true, isMicListening: false, isPlaying: false);
  }

  Future<void> saveMoment([String? reflection]) async {
    final effectiveReflection = (reflection ?? state.reflectionText).trim();
    if (effectiveReflection.isNotEmpty) {
      final repository = await ref.read(hifzRepositoryProvider.future);
      final moment = HifzMoment()
        ..surahIndex = state.surahNumber
        ..verseNumber = state.fromVerse + state.currentVerseIndex
        ..reflection = effectiveReflection
        ..createdAt = DateTime.now();
      await repository.saveMoment(moment);
    }

    final lastVerseIndex = state.toVerse - state.fromVerse;
    if (state.currentVerseIndex >= lastVerseIndex) {
      await _finishSession();
      return;
    }

    state = state.copyWith(
      currentVerseIndex: state.currentVerseIndex + 1,
      currentStage: 1,
      showMomentPrompt: false,
      reflectionText: '',
    );
    _alreadyHidden.clear();
    await _loadCurrentVerseWords();
    await _runCurrentStage();
  }

  void setReflectionText(String text) {
    state = state.copyWith(reflectionText: text);
  }

  Future<void> skipMoment() async {
    await saveMoment(null);
  }

  Future<void> saveMomentFromState() async {
    await saveMoment(state.reflectionText);
    state = state.copyWith(reflectionText: '');
  }

  Future<void> toggleAudio() async {
    if (state.isPlaying) {
      await ref.read(audioControllerProvider.notifier).stopAudio();
      state = state.copyWith(isPlaying: false);
      return;
    }
    await _playVerseAudio();
  }

  Future<void> toggleMic() async {
    if (state.isMicListening) {
      await _stopMic();
      return;
    }
    if (state.currentStage >= 3) {
      await _startMicDetailed();
    } else {
      await _startMicLight();
    }
  }

  Future<void> nextStage() async {
    await nextStageOrVerse();
  }

  void openThawaabDedication(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VefaPage(isSelectionMode: true)),
    );
  }

  Future<void> onUserRecited(String recitedText) async {
    final tokens = recitedText.split(RegExp(r'\s+')).where((e) => e.trim().isNotEmpty).toList();
    final words = List<ShadowWordEntry>.from(state.words);
    var correct = 0;
    var wrong = 0;
    var tokenIndex = 0;

    for (int i = 0; i < words.length; i++) {
      if (!words[i].isHidden || words[i].isAyahMarker) {
        continue;
      }
      final spoken = tokenIndex < tokens.length ? tokens[tokenIndex] : '';
      tokenIndex++;
      final result = TajweedNormalizer.compareWord(spoken: spoken, expected: words[i].word);
      if (result == WordMatchResult.correct) {
        words[i] = words[i].copyWith(isHidden: false, revealedCorrectly: true);
        correct++;
      } else {
        wrong++;
      }
    }

    _stageCorrect += correct;
    _stageWrong += wrong;
    final verseText = _verseText;
    final hasanat = HasanatCalculator.calculate(verseText);
    state = state.copyWith(
      words: words,
      sessionHashanat: state.sessionHashanat + hasanat,
      correctWords: state.correctWords + correct,
      wrongWords: state.wrongWords + wrong,
    );

    await nextStageOrVerse();
  }

  List<int> selectWordsToHide(
    List<String> words,
    double percentage,
    List<int> alreadyHidden,
  ) {
    final target = (words.length * percentage).ceil().clamp(0, words.length);
    final hidden = <int>{...alreadyHidden};
    final particle = <int>[];
    final suffix = <int>[];
    final root = <int>[];

    for (int i = 0; i < words.length; i++) {
      final w = TajweedNormalizer.normalize(words[i]);
      if (w.isEmpty) {
        continue;
      }
      if (_isParticle(w)) {
        particle.add(i);
      } else if (_looksLikeSuffixWord(w)) {
        suffix.add(i);
      } else {
        root.add(i);
      }
    }

    void take(List<int> source) {
      for (final idx in source) {
        if (hidden.length >= target) {
          break;
        }
        hidden.add(idx);
      }
    }

    take(particle);
    take(suffix);
    take(root);

    return hidden.toList()..sort();
  }

  Future<void> _runCurrentStage() async {
    _stageCorrect = 0;
    _stageWrong = 0;
    _stageStartedAt = DateTime.now();

    if (state.currentStage <= 2) {
      await _playVerseAudio();
      if (state.currentStage == 2) {
        await _startMicLight();
      }
      await Future<void>.delayed(const Duration(seconds: 2));
      await _stopMic();
      await nextStageOrVerse();
      return;
    }

    await _startMicDetailed();
  }

  Future<void> _startMicLight() async {
    _speechService ??= TasmiSpeechService();
    await _speechService!.initialize();
    await _speechSubscription?.cancel();
    _speechSubscription = _speechService!.wordStream.listen((_) {});
    final started = await _speechService!.startListening();
    state = state.copyWith(isMicListening: started);
  }

  Future<void> _startMicDetailed() async {
    _speechService ??= TasmiSpeechService();
    await _speechService!.initialize();
    await _speechSubscription?.cancel();
    final buffer = StringBuffer();
    _speechSubscription = _speechService!.wordStream.listen((token) {
      if (buffer.isNotEmpty) {
        buffer.write(' ');
      }
      buffer.write(token);
    });

    final started = await _speechService!.startListening();
    state = state.copyWith(isMicListening: started);
    await Future<void>.delayed(const Duration(seconds: 6));
    await _stopMic();
    await onUserRecited(buffer.toString());
  }

  Future<void> _stopMic() async {
    await _speechService?.stopListening();
    state = state.copyWith(isMicListening: false);
  }

  Future<void> _playVerseAudio() async {
    final surahStr = state.surahNumber.toString().padLeft(3, '0');
    final ayah = state.fromVerse + state.currentVerseIndex;
    final ayahStr = ayah.toString().padLeft(3, '0');
    final url = 'https://everyayah.com/data/Husary_128kbps/$surahStr$ayahStr.mp3';

    state = state.copyWith(isPlaying: true);
    await ref.read(audioControllerProvider.notifier).playAudio(
      url,
      surahName: quran.getSurahNameArabic(state.surahNumber),
      ayahNumber: ayah,
    );
    await Future<void>.delayed(const Duration(seconds: 4));
    state = state.copyWith(isPlaying: false);
  }

  Future<void> _loadCurrentVerseWords() async {
    final ayah = state.fromVerse + state.currentVerseIndex;
    final verse = quran.getVerse(state.surahNumber, ayah, verseEndSymbol: false);
    final words = verse
        .split(' ')
        .where((w) => w.trim().isNotEmpty)
        .map(
          (w) => ShadowWordEntry(
            word: w,
            isAyahMarker: false,
            isHidden: false,
            revealedCorrectly: false,
          ),
        )
        .toList();
    state = state.copyWith(words: words);
    await _applyHidingForStage();
  }

  Future<void> _applyHidingForStage() async {
    final base = List<ShadowWordEntry>.from(state.words);
    if (state.currentStage <= 2) {
      state = state.copyWith(words: base.map((e) => e.copyWith(isHidden: false)).toList());
      return;
    }

    final percentages = {3: 0.30, 4: 0.60, 5: 1.0};
    final target = percentages[state.currentStage] ?? 0.30;
    final plainWords = base.map((e) => e.word).toList();
    final hidden = selectWordsToHide(plainWords, target, _alreadyHidden);
    _alreadyHidden
      ..clear()
      ..addAll(hidden);

    final next = <ShadowWordEntry>[];
    for (int i = 0; i < base.length; i++) {
      final prev = base[i];
      if (prev.revealedCorrectly) {
        next.add(prev.copyWith(isHidden: false));
        continue;
      }
      next.add(prev.copyWith(isHidden: hidden.contains(i)));
    }

    state = state.copyWith(words: next);
  }

  void _captureStageStats() {
    final updated = Map<int, StageResult>.from(state.stageResults);
    updated[state.currentStage] = StageResult(
      totalWords: state.words.length,
      correctWords: _stageCorrect,
      wrongWords: _stageWrong,
    );
    state = state.copyWith(stageResults: updated);

    final duration = DateTime.now().difference(_stageStartedAt ?? DateTime.now());
    if (state.currentStage == 5) {
      final ayah = state.fromVerse + state.currentVerseIndex;
      _sessionRows.add(
        HifzSession()
          ..surahIndex = state.surahNumber
          ..fromVerse = ayah
          ..toVerse = ayah
          ..method = 'interactive_shadow'
          ..date = DateTime.now()
          ..correctWords = _stageCorrect
          ..wrongWords = _stageWrong
          ..durationSeconds = duration.inSeconds,
      );
    }
  }

  Future<void> _finishSession() async {
    final repository = await ref.read(hifzRepositoryProvider.future);
    var totalCorrect = 0;
    var totalWrong = 0;

    for (final session in _sessionRows) {
      totalCorrect += session.correctWords;
      totalWrong += session.wrongWords;
      await repository.saveSession(session);
      final record =
          await repository.getVerseRecord(session.surahIndex, session.fromVerse) ??
              (HifzVerseRecord()
                ..surahIndex = session.surahIndex
                ..verseNumber = session.fromVerse
                ..intervalDays = 1
                ..easinessFactor = 2.5
                ..nextReviewDate = DateTime.now()
                ..lastReviewDate = DateTime.now()
                ..totalSessions = 0
                ..correctSessions = 0
                ..lastMethodUsed = 'interactive_shadow');

      final quality = session.wrongWords == 0 ? 5 : (session.wrongWords <= 2 ? 3 : 1);
      final schedule = SpacedRepetitionEngine.calculateNext(
        currentIntervalDays: record.intervalDays,
        easinessFactor: record.easinessFactor,
        quality: quality,
      );

      record
        ..intervalDays = schedule.nextIntervalDays
        ..easinessFactor = schedule.newEasinessFactor
        ..nextReviewDate = schedule.nextReviewDate
        ..lastReviewDate = DateTime.now()
        ..totalSessions = record.totalSessions + 1
        ..correctSessions = record.correctSessions + (quality >= 3 ? 1 : 0)
        ..lastMethodUsed = 'interactive_shadow';

      await repository.saveVerseRecord(record);
    }

    final total = totalCorrect + totalWrong;
    final accuracy = total == 0 ? 0.0 : totalCorrect / total;
    state = state.copyWith(
      finished: true,
      showMomentPrompt: false,
      isMicListening: false,
      isPlaying: false,
      accuracy: accuracy,
    );

    await ref.read(analyticsServiceProvider).logHifzSessionComplete(
          ayahsCount: _sessionRows.length,
          accuracy: accuracy,
          hasanat: state.sessionHashanat,
        );
  }

  bool _isParticle(String word) {
    const particles = ['ال', 'و', 'ف', 'ب', 'ل', 'من', 'في', 'على'];
    return particles.any((p) => word == p || word.startsWith(p));
  }

  bool _looksLikeSuffixWord(String word) {
    const suffixes = ['ون', 'ين', 'ات', 'ان', 'هم', 'كم', 'نا', 'ه'];
    return suffixes.any(word.endsWith);
  }

  String get _verseText {
    final ayah = state.fromVerse + state.currentVerseIndex;
    return quran.getVerse(state.surahNumber, ayah, verseEndSymbol: false);
  }
}
