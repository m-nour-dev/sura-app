import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranData {
  final Map<String, String> tafsir;
  final Map<String, String> tajweed;
  final Map<String, String> translation;

  QuranData({
    required this.tafsir,
    required this.tajweed,
    required this.translation,
  });

  factory QuranData.empty() => QuranData(tafsir: {}, tajweed: {}, translation: {});
}

final quranDataProvider = FutureProvider<QuranData>((ref) async {
  try {
    final results = await Future.wait([
      rootBundle.loadString('assets/data/tafseer.json'),
      rootBundle.loadString('assets/data/tajweed.json'),
      rootBundle.loadString('assets/data/quran_tr.json'),
    ]);

    final Map<String, dynamic> tafsirRaw = json.decode(results[0]);
    final Map<String, dynamic> tajweedRaw = json.decode(results[1]);
    final Map<String, dynamic> trRaw = json.decode(results[2]);

    // Robustly convert to Map<String, String>
    final Map<String, String> processedTafsir = tafsirRaw.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
    final Map<String, String> processedTajweed = tajweedRaw.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );

    // Translation is a list of objects with 'chapter', 'verse', 'text'
    final List<dynamic> trList = trRaw['quran'] ?? [];
    final Map<String, String> processedTr = {};
    for (var item in trList) {
      if (item['chapter'] != null && item['verse'] != null) {
        processedTr['${item['chapter']}_${item['verse']}'] = (item['text'] ?? '').toString();
      }
    }

    return QuranData(
      tafsir: processedTafsir,
      tajweed: processedTajweed,
      translation: processedTr,
    );
  } catch (e) {
    print('Error loading Quran data: $e');
    return QuranData.empty();
  }
});
