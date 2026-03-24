import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class TafsirService {
  static final Map<String, Map<int, String>> _tafseerCache = {};

  static Future<void> loadTafsir() async {
    try {
      final languageCode = Intl.getCurrentLocale();
      final isTurkish = languageCode.startsWith('tr');
      final filePath = isTurkish ? 'assets/data/tafseer_tr.json' : 'assets/data/tafseer.json';
      
      final String jsonString = await rootBundle.loadString(filePath);
      // Parse JSON and cache by surah number
      // Format: {"1": {"1": "تفسير الآية 1", "2": "تفسير الآية 2"}}
    } catch (e) {
      print('Error loading tafsir: $e');
    }
  }

  static String? getTafsir(int surahNumber, int ayahNumber) {
    // Return cached tafsir
    return _tafseerCache[surahNumber.toString()]?[ayahNumber];
  }

  static Future<void> cacheTafsir(Map<String, Map<int, String>> data) async {
    _tafseerCache.addAll(data);
  }
}
