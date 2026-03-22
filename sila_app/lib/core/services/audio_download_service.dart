import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/core/services/reciter_service.dart';

class AudioDownloadProgress {
  final int completed;
  final int total;
  final int surah;
  final int ayah;

  const AudioDownloadProgress({
    required this.completed,
    required this.total,
    required this.surah,
    required this.ayah,
  });
}

class AudioDownloadService {
  static const String _cacheRoot = 'audio_cache';

  static Future<Directory> _reciterDirectory(ReciterModel reciter) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}${Platform.pathSeparator}$_cacheRoot${Platform.pathSeparator}${reciter.folderName}');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  static Future<String> localAyahPath(
    ReciterModel reciter,
    int surahNumber,
    int ayahNumber,
  ) async {
    final surah = surahNumber.toString().padLeft(3, '0');
    final ayah = ayahNumber.toString().padLeft(3, '0');
    final dir = await _reciterDirectory(reciter);
    return '${dir.path}${Platform.pathSeparator}$surah$ayah.mp3';
  }

  static Future<int> totalAyahCount() async {
    var total = 0;
    for (var s = 1; s <= 114; s++) {
      total += quran.getVerseCount(s);
    }
    return total;
  }

  static Future<int> downloadedAyahCount(ReciterModel reciter) async {
    final dir = await _reciterDirectory(reciter);
    if (!dir.existsSync()) return 0;
    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.mp3'))
        .length;
  }

  static Future<void> downloadAllForReciter(
    ReciterModel reciter, {
    required void Function(AudioDownloadProgress progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final dio = Dio();
    final total = await totalAyahCount();
    var completed = 0;

    for (var surah = 1; surah <= 114; surah++) {
      final ayahCount = quran.getVerseCount(surah);
      for (var ayah = 1; ayah <= ayahCount; ayah++) {
        final localPath = await localAyahPath(reciter, surah, ayah);
        final localFile = File(localPath);

        if (!localFile.existsSync()) {
          final url = reciter.buildAyahUrl(surah, ayah);
          await dio.download(url, localPath, cancelToken: cancelToken);
        }

        completed++;
        onProgress(
          AudioDownloadProgress(
            completed: completed,
            total: total,
            surah: surah,
            ayah: ayah,
          ),
        );
      }
    }
  }
}
