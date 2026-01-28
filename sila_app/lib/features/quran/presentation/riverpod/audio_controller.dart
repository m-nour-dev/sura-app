import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_controller.g.dart';

// Singleton audio player - shared across all instances
// This prevents multiple AudioPlayer instances from interrupting each other
class _AudioPlayerSingleton {
  static final _AudioPlayerSingleton _instance = _AudioPlayerSingleton._internal();
  factory _AudioPlayerSingleton() => _instance;
  _AudioPlayerSingleton._internal();

  final AudioPlayer player = AudioPlayer();
  bool isLoading = false;
  String? currentUrl;
}

@riverpod
class AudioController extends _$AudioController {
  final _singleton = _AudioPlayerSingleton();
  
  @override
  Raw<AudioPlayer> build() {
    // Dispose is handled by the singleton, not by individual instances
    return _singleton.player;
  }

  Future<void> playAudio(String url) async {
    // THIS is the critical fix - use singleton's isLoading flag
    // This ensures that even if riverpod creates multiple controller instances,
    // they all share the same loading state
    if (_singleton.isLoading) {
      print("⚠️ Already loading audio, ignoring tap");
      return;
    }

    // If same URL is already playing, restart it
    if (_singleton.currentUrl == url && _singleton.player.playing) {
      print("🔄 Already playing this audio, restarting...");
      await _singleton.player.seek(Duration.zero);
      return;
    }

    _singleton.isLoading = true;

    try {
      // Stop any currently playing audio first
      if (_singleton.player.playing) {
        await _singleton.player.stop();
      }
      
      print("🎵 Attempting to play: $url");
      _singleton.currentUrl = url;
      
      // Use setUrl directly
      await _singleton.player.setUrl(url);
      
      print("✅ Audio loaded successfully");
      
      // Start playback
      await _singleton.player.play();
      
      print("▶️ Playback started");
      
    } on PlayerException catch (e) {
      print("❌ PlayerException: ${e.code} - ${e.message}");
      _singleton.currentUrl = null;
      rethrow;
    } on PlayerInterruptedException catch (e) {
      print("⚠️ PlayerInterruptedException: $e");
      _singleton.currentUrl = null;
      rethrow;
    } catch (e) {
      print("❌ Unexpected error: $e");
      _singleton.currentUrl = null;
      rethrow;
    } finally {
      _singleton.isLoading = false;
    }
  }

  Future<void> stopAudio() async {
    await _singleton.player.stop();
    _singleton.currentUrl = null;
    _singleton.isLoading = false;
  }
}

// State provider to track currently playing Ayah ID (for highlighting)
@riverpod
class PlayingAyahId extends _$PlayingAyahId {
  @override
  int? build() => null;

  void setPlaying(int? ayahNumber) {
    state = ayahNumber;
  }
}
