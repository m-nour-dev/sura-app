import 'dart:convert';
import 'dart:math';

import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_record.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_ar.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_en.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_fr.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_tr.dart';

class DailyStatusCalculator {
  static final Random _random = Random();
  static final Map<String, String> _dailyTextCache = {};

  static int _customCount(IbadahRecord record, List<String> customIbadahs) {
    if (customIbadahs.isEmpty) return 0;
    var count = 0;
    try {
      final currentNote = record.personalNote ?? '{}';
      final map = jsonDecode(currentNote) as Map<String, dynamic>;
      if (map.containsKey('custom') && map['custom'] is Map) {
        final customMap = map['custom'] as Map<String, dynamic>;
        for (final name in customIbadahs) {
          if (customMap[name] == true) count++;
        }
      }
    } catch (_) {}
    return count;
  }

  static int completedCount(IbadahRecord record,
      {required bool isMale, List<String>? customIbadahs}) {
    var count = 0;

    // 1. 5 Prayers (Visible)
    if (record.fajrStatus > 0) count++;
    if (record.dhuhrStatus > 0) count++;
    if (record.asrStatus > 0) count++;
    if (record.maghribStatus > 0) count++;
    if (record.ishaStatus > 0) count++;

    // 2. 5 Standard Items (Visible)
    if (record.readWird) count++;
    if (record.readAzkarSabah) count++;
    if (record.readAzkarMasa) count++;
    if (record.didTasbih) count++;
    if (record.didHifz || record.didTasmi) count++;

    // We intentionally skip counting "In Masjid" or "Dhikr" separately
    // to match exactly the 10 rows shown in the UI.

    // 3. Custom Ibadahs
    if (customIbadahs != null) {
      count += _customCount(record, customIbadahs);
    }

    return count;
  }

  static int totalCount({required bool isMale, List<String>? customIbadahs}) {
    // 10 base visible items + any active custom ibadahs
    return 10 + (customIbadahs?.length ?? 0);
  }

  static double completionRatio(IbadahRecord record,
      {required bool isMale, List<String>? customIbadahs}) {
    final total = totalCount(isMale: isMale, customIbadahs: customIbadahs);
    if (total == 0) return 0.0;
    return completedCount(record,
            isMale: isMale, customIbadahs: customIbadahs) /
        total;
  }

  static String getDailyStatusText(IbadahRecord record,
      {required bool isMale,
      required String languageCode,
      List<String>? customIbadahs}) {
    var texts = <String>[];
    final ratio =
        completionRatio(record, isMale: isMale, customIbadahs: customIbadahs);

    if (ratio >= 1.0) {
      if (languageCode == 'ar') {
        texts = [
          '«وَالَّذِينَ جَاهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا»\nأتممت وردك اليوم كاملاً، هنيئاً لك هذا السعي 🤍',
          'طوبى لك! يومك صحيفة بيضاء مُلئت بنور الطاعات. تقبل الله منك 👑',
          '«أَحَبُّ الْأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ»\nأنت اليوم بطل في ميزان الاستقامة، استمر! 🌟',
          'اكتمل العقد! صلوات، أذكار، ومناجاة.. هنيئاً لقلبك هذا النعيم 🕊️'
        ];
      } else if (languageCode == 'fr') {
        texts = [
          'Toutes vos adorations sont accomplies aujourd\'hui, félicitations 🤍',
          'Magnifique journée de spiritualité ! Qu\'Allah accepte 🌟'
        ];
      } else if (languageCode == 'tr') {
        texts = [
          'Bugün tüm ibadetlerini tamamladın, tebrikler 🤍',
          'Muhteşem bir gün! Allah kabul etsin 🌟'
        ];
      } else {
        texts = [
          'You have completed your full routine today, congratulations! 🤍',
          'A perfect day of devotion. May Allah accept your efforts 🌟'
        ];
      }
    } else if (languageCode == 'ar') {
      if (ratio >= 0.8) {
        texts = DailyStatusQuotesAr.excellent;
      } else if (ratio >= 0.4) {
        texts = DailyStatusQuotesAr.average;
      } else {
        texts = DailyStatusQuotesAr.poor;
      }
    } else if (languageCode == 'fr') {
      if (ratio >= 0.8) {
        texts = DailyStatusQuotesFr.excellent;
      } else if (ratio >= 0.4) {
        texts = DailyStatusQuotesFr.average;
      } else {
        texts = DailyStatusQuotesFr.poor;
      }
    } else if (languageCode == 'tr') {
      if (ratio >= 0.8) {
        texts = DailyStatusQuotesTr.excellent;
      } else if (ratio >= 0.4) {
        texts = DailyStatusQuotesTr.average;
      } else {
        texts = DailyStatusQuotesTr.poor;
      }
    } else {
      if (ratio >= 0.8) {
        texts = DailyStatusQuotesEn.excellent;
      } else if (ratio >= 0.4) {
        texts = DailyStatusQuotesEn.average;
      } else {
        texts = DailyStatusQuotesEn.poor;
      }
    }

    if (texts.isEmpty) return '';

    final dayKey =
        record.date.year * 10000 + record.date.month * 100 + record.date.day;
    final cacheKey = '${dayKey}_$languageCode';
    final cached = _dailyTextCache[cacheKey];
    if (cached != null && texts.contains(cached)) return cached;

    final baseSeed =
        record.date.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final idx = (baseSeed + (baseSeed % 13) + _random.nextInt(texts.length)) %
        texts.length;
    final selected = texts[idx];
    _dailyTextCache[cacheKey] = selected;
    return selected;
  }

  // Backward compatibility or alternative name
  static String getDailyQuote(IbadahRecord record, String languageCode,
      {List<String>? customIbadahs}) {
    return getDailyStatusText(record,
        isMale: true, languageCode: languageCode, customIbadahs: customIbadahs);
  }
}
