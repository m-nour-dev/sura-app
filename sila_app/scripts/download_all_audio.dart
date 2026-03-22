import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/core/services/reciter_service.dart';

Future<void> main(List<String> args) async {
  final projectRoot = Directory.current;
  final outputDir = Directory('${projectRoot.path}${Platform.pathSeparator}assets${Platform.pathSeparator}audio');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final selectedReciters = _parseReciters(args);
  final dio = Dio();
  final totalAyahs = _totalAyahs();
  final totalFiles = totalAyahs * selectedReciters.length;
  var globalDone = 0;

  stdout.writeln('Starting audio download to: ${outputDir.path}');
  stdout.writeln('Reciters: ${selectedReciters.length} | Ayahs each: $totalAyahs | Total files: $totalFiles');

  for (var r = 0; r < selectedReciters.length; r++) {
    final reciter = selectedReciters[r];
    final reciterDir = Directory('${outputDir.path}${Platform.pathSeparator}${reciter.folderName}');
    if (!reciterDir.existsSync()) {
      reciterDir.createSync(recursive: true);
    }

    stdout.writeln('\\n[${r + 1}/${selectedReciters.length}] ${reciter.nameArabic} (${reciter.id})');

    for (var surah = 1; surah <= 114; surah++) {
      final ayahCount = quran.getVerseCount(surah);
      for (var ayah = 1; ayah <= ayahCount; ayah++) {
        final name = '${surah.toString().padLeft(3, '0')}${ayah.toString().padLeft(3, '0')}.mp3';
        final target = File('${reciterDir.path}${Platform.pathSeparator}$name');
        if (!target.existsSync()) {
          final url = reciter.buildAyahUrl(surah, ayah);
          await _downloadWithRetry(dio, url, target.path);
        }

        globalDone++;
        if (globalDone % 100 == 0 || globalDone == totalFiles) {
          final progress = ((globalDone / totalFiles) * 100).toStringAsFixed(2);
          stdout.writeln('Progress: $globalDone/$totalFiles ($progress%) - S$surah A$ayah');
        }
      }
    }
  }

  stdout.writeln('\\nDone. All selected reciters downloaded to assets/audio/.');
}

List<ReciterModel> _parseReciters(List<String> args) {
  final all = ReciterService.availableReciters;
  final idsArg = args.where((e) => e.startsWith('--reciters=')).map((e) => e.substring('--reciters='.length)).toList();
  if (idsArg.isEmpty) {
    return all;
  }

  final ids = idsArg.first.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();
  final picked = all.where((r) => ids.contains(r.id)).toList();
  if (picked.isEmpty) {
    throw ArgumentError('No valid reciter ids found. Use ids from ReciterService.availableReciters');
  }
  return picked;
}

int _totalAyahs() {
  var total = 0;
  for (var i = 1; i <= 114; i++) {
    total += quran.getVerseCount(i);
  }
  return total;
}

Future<void> _downloadWithRetry(Dio dio, String url, String targetPath) async {
  const attempts = 3;
  for (var i = 1; i <= attempts; i++) {
    try {
      await dio.download(url, targetPath);
      return;
    } catch (e) {
      if (i == attempts) rethrow;
      await Future<void>.delayed(Duration(milliseconds: 500 * i));
    }
  }
}
