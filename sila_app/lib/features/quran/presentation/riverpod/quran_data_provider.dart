import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranData {

  QuranData({
    required this.tafsir,
    required this.tajweed,
    required this.translation,
  });

  factory QuranData.empty() => QuranData(tafsir: {}, tajweed: {}, translation: {});
  final Map<String, String> tafsir;
  final Map<String, String> tajweed;
  final Map<String, String> translation;
}

final appLocaleProvider = StateProvider<Locale>((ref) => const Locale('ar', 'SA'));

final quranDataProvider = FutureProvider<QuranData>((ref) async {
  try {
    // Watch the locale provider to re-trigger this future when locale changes
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    
    final isTurkish = languageCode == 'tr';
    final isEnglish = languageCode == 'en';
    final isFrench = languageCode == 'fr';

    // Default paths (Arabic)
    String? quranTranslationPath;
    String tafseerPath = 'assets/data/tafseer.json';
    String tajweedPath = 'assets/data/tajweed.json';

    if (isTurkish) {
      quranTranslationPath = 'assets/data/quran_tr.json';
      tafseerPath = 'assets/data/tafseer_tr.json';
      tajweedPath = 'assets/data/tajweed_tr.json';
    } else if (isEnglish) {
      quranTranslationPath = 'assets/data/translation_en.json';
      tafseerPath = 'assets/data/tafseer_en.json';
    } else if (isFrench) {
      quranTranslationPath = 'assets/data/translation_fr.json';
      tafseerPath = 'assets/data/tafseer_fr.json';
    }

    final List<Future<String>> futures = [
      rootBundle.loadString(tafseerPath),
      rootBundle.loadString(tajweedPath),
    ];
    
    if (quranTranslationPath != null) {
      futures.add(rootBundle.loadString(quranTranslationPath));
    }

    final results = await Future.wait(futures);

    final Map<String, dynamic> tafsirRaw = json.decode(results[0]);
    final Map<String, dynamic> tajweedRaw = json.decode(results[1]);
    
    Map<String, dynamic> trRaw = {};
    if (quranTranslationPath != null) {
      trRaw = json.decode(results[2]);
    }

    // Robustly convert to Map<String, String> for Tafsir and Tajweed
    final processedTafsir = tafsirRaw.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
    final processedTajweed = tajweedRaw.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );

    // Process Translation (Handle both nested list and flat map)
    final processedTr = <String, String>{};
    if (trRaw.containsKey('quran') && trRaw['quran'] is List) {
      // Structure of quran_tr.json
      final List<dynamic> trList = trRaw['quran'];
      for (var item in trList) {
        if (item['chapter'] != null && item['verse'] != null) {
          processedTr['${item['chapter']}_${item['verse']}'] = (item['text'] ?? '').toString();
        }
      }
    } else {
      // Flat map structure (translation_en.json, translation_fr.json)
      trRaw.forEach((key, value) {
        processedTr[key.toString()] = value.toString();
      });
    }

    return QuranData(
      tafsir: processedTafsir,
      tajweed: processedTajweed,
      translation: processedTr,
    );
  } catch (e) {
    debugPrint('Error loading Quran data: $e');
    return QuranData.empty();
  }
});
