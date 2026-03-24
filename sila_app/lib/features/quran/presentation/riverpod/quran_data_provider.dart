import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
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
    final languageCode = Intl.getCurrentLocale();
    final isTurkish = languageCode.startsWith('tr');

    // Load Quran translation
    final quranTranslationPath = 'assets/data/quran_tr.json';
    
    // Load Tafseer based on language
    final tafseerPath = isTurkish ? 'assets/data/tafseer_tr.json' : 'assets/data/tafseer.json';
    
    // Load Tajweed based on language
    final tajweedPath = isTurkish ? 'assets/data/tajweed_tr.json' : 'assets/data/tajweed.json';

    final results = await Future.wait([
      rootBundle.loadString(tafseerPath),
      rootBundle.loadString(tajweedPath),
      rootBundle.loadString(quranTranslationPath),
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
