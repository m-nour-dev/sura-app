import 'dart:math';

import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_record.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_ar.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_en.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_fr.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_quotes_tr.dart';

class DailyStatusCalculator {
  static final Random _random = Random();
  static final Map<int, String> _dailyTextCache = {};

  static String getDailyQuote(IbadahRecord record, String languageCode) {
    var texts = <String>[];
    final double ratio = record.completionRatio;

    if (languageCode == 'ar') {
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

    final dayKey = record.date.year * 10000 + record.date.month * 100 + record.date.day;
    final cached = _dailyTextCache[dayKey];
    if (cached != null && texts.contains(cached)) return cached;

    final baseSeed = record.date.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final idx = (baseSeed + (baseSeed % 13) + _random.nextInt(texts.length)) % texts.length;
    final selected = texts[idx];
    _dailyTextCache[dayKey] = selected;
    return selected;
  }
}
