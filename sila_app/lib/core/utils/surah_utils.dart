import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class SurahUtils {
  static String getLocalizedSurahName(BuildContext context, int surahNumber) {
    final locale = context.locale.languageCode;
    if (locale == 'ar') {
      return quran.getSurahNameArabic(surahNumber);
    } else {
      // For Turkish and others, use the transliterated name
      // We can improve this by having a specific Turkish list if needed
      return quran.getSurahName(surahNumber);
    }
  }
}
