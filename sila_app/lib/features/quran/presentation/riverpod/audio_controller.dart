import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_controller.g.dart';

@riverpod
class AudioController extends _$AudioController {
  final AudioPlayer _player = AudioPlayer();

  @override
  Raw<AudioPlayer> build() {
    // Dipose player when provider is destroyed
    ref.onDispose(() {
      _player.dispose();
    });
    return _player;
  }

  Future<void> playAudio(String url) async {
    try {
      if (_player.playing) {
        await _player.stop();
      }
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print("Error playing audio: $e");
      // Could throw rethrow here to let UI handle it
      throw e;
    }
  }

  Future<void> stopAudio() async {
    await _player.stop();
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
