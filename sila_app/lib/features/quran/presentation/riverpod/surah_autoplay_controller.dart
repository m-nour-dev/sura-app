import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/providers/reciter_provider.dart';
import 'package:sila_app/features/quran/presentation/riverpod/audio_controller.dart';

/// Auto-play state for a surah
class AutoPlayState {

  const AutoPlayState({
    required this.isPlaying,
    required this.isPaused,
    required this.currentAyahNumber,
    required this.totalAyahs,
    required this.isFinished,
  });

  factory AutoPlayState.initial(int totalAyahs) => AutoPlayState(
    isPlaying: false,
    isPaused: false,
    currentAyahNumber: 1,
    totalAyahs: totalAyahs,
    isFinished: false,
  );
  final bool isPlaying;
  final bool isPaused;
  final int currentAyahNumber;
  final int totalAyahs;
  final bool isFinished;

  AutoPlayState copyWith({
    bool? isPlaying,
    bool? isPaused,
    int? currentAyahNumber,
    int? totalAyahs,
    bool? isFinished,
  }) {
    return AutoPlayState(
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      currentAyahNumber: currentAyahNumber ?? this.currentAyahNumber,
      totalAyahs: totalAyahs ?? this.totalAyahs,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

/// Controller for managing surah-wide auto-play functionality
class SurahAutoPlayController extends StateNotifier<AutoPlayState> {

  SurahAutoPlayController(this.ref, int totalAyahs) 
      : super(AutoPlayState.initial(totalAyahs)) {
    ref.onDispose(dispose);
  }
  final Ref ref;
  StreamSubscription? _completionSubscription;
  Timer? _timeoutTimer;
  int? _currentPlayingAyahNumber;

  @override
  void dispose() {
    _completionSubscription?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  /// Start auto-play from the specified ayah number
  Future<void> startAutoPlay(
    int surahNumber,
    int startAyahNumber,
    int totalAyahs,
    String surahName,
  ) async {
    try {
      state = state.copyWith(
        isPlaying: true,
        isPaused: false,
        currentAyahNumber: startAyahNumber,
        totalAyahs: totalAyahs,
        isFinished: false,
      );

      await _playAyah(surahNumber, startAyahNumber, surahName);
    } catch (e) {
      state = state.copyWith(isPlaying: false);
      rethrow;
    }
  }

  /// Play a specific ayah and listen for completion to auto-advance
  Future<void> _playAyah(
    int surahNumber,
    int ayahNumber,
    String surahName,
  ) async {
    try {
      _currentPlayingAyahNumber = ayahNumber;
      _timeoutTimer?.cancel();
      
      final url = ref
          .read(reciterControllerProvider.notifier)
          .buildAyahUrl(surahNumber, ayahNumber);

      final audioController = ref.read(audioControllerProvider.notifier);
      
      await audioController.playAudio(
        url,
        surahName: surahName,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );

      // Listen for when this ayah finishes
      _listenForCompletion(surahNumber, ayahNumber, surahName);
      
      // Set timeout as fallback (60 seconds max for any ayah)
      _timeoutTimer = Timer(const Duration(seconds: 60), () {
        if (_currentPlayingAyahNumber == ayahNumber && state.isPlaying) {
          _advanceToNextAyah(surahNumber, ayahNumber, surahName);
        }
      });
    } catch (e) {
      state = state.copyWith(isPlaying: false);
      rethrow;
    }
  }

  /// Advance to the next ayah
  void _advanceToNextAyah(int surahNumber, int currentAyah, String surahName) {
    if (!state.isPlaying || state.isPaused) return;

    final nextAyah = currentAyah + 1;
    
    if (nextAyah <= state.totalAyahs) {
      // Play next ayah in same surah
      _playAyah(surahNumber, nextAyah, surahName).then((_) {
        state = state.copyWith(currentAyahNumber: nextAyah);
      }).catchError((e) {
        // Silently stop on error
        stopAutoPlay();
      });
    } else {
      // Surah finished
      state = state.copyWith(
        isPlaying: false,
        isFinished: true,
      );
    }
  }

  /// Listen for audio completion and advance to next ayah
  void _listenForCompletion(int surahNumber, int ayahNumber, String surahName) {
    // Cancel previous subscription
    _completionSubscription?.cancel();
    
    final audioController = ref.read(audioControllerProvider.notifier);
    
    _completionSubscription = audioController.onPlayerComplete.listen(
      (_) {
        // Cancel timeout since we got completion event
        _timeoutTimer?.cancel();
        _advanceToNextAyah(surahNumber, ayahNumber, surahName);
      },
      onError: (error) {
        _timeoutTimer?.cancel();
        stopAutoPlay();
      },
      cancelOnError: false,
    );
  }

  /// Pause auto-play (can be resumed)
  Future<void> pauseAutoPlay() async {
    await ref.read(audioControllerProvider.notifier).stopAudio();
    state = state.copyWith(
      isPlaying: false,
      isPaused: true,
    );
  }

  /// Resume auto-play from paused state
  Future<void> resumeAutoPlay(int surahNumber, String surahName) async {
    try {
      state = state.copyWith(isPlaying: true, isPaused: false);
      await _playAyah(surahNumber, state.currentAyahNumber, surahName);
    } catch (e) {
      state = state.copyWith(isPlaying: false);
      rethrow;
    }
  }

  /// Stop auto-play completely
  Future<void> stopAutoPlay() async {
    await ref.read(audioControllerProvider.notifier).stopAudio();
    state = state.copyWith(
      isPlaying: false,
      isPaused: false,
      currentAyahNumber: 1,
      isFinished: false,
    );
  }

  /// Skip to a specific ayah
  Future<void> skipToAyah(
    int surahNumber,
    int ayahNumber,
    String surahName,
  ) async {
    try {
      state = state.copyWith(currentAyahNumber: ayahNumber);
      await _playAyah(surahNumber, ayahNumber, surahName);
    } catch (e) {
      rethrow;
    }
  }
}

// Provider for SurahAutoPlayController
final surahAutoPlayControllerProvider = StateNotifierProvider.family<
    SurahAutoPlayController,
    AutoPlayState,
    int>((ref, totalAyahs) {
  return SurahAutoPlayController(ref, totalAyahs);
});
