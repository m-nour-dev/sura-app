import 'package:flutter/material.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';

class QuranUIUtils {
  static Color getBackgroundColor(QuranThemeMode mode) {
    if (mode == QuranThemeMode.dark) return const Color(0xFF0F172A); // Night Deep
    if (mode == QuranThemeMode.sepia) return const Color(0xFFF5EDD8); // warm parchment
    return const Color(0xFFFDFBF7); // Parchment – design system
  }

  static Color getTextColor(QuranThemeMode mode) {
    if (mode == QuranThemeMode.dark) return const Color(0xFFE8EEF4);
    if (mode == QuranThemeMode.sepia) return const Color(0xFF3D2B1F);
    return const Color(0xFF0F172A); // Night Deep – design system
  }

  static Color getAccentColor(QuranThemeMode mode) {
    if (mode == QuranThemeMode.dark) return const Color(0xFFD97706); // Islamic Gold in dark
    if (mode == QuranThemeMode.sepia) return const Color(0xFF6D4C41);
    return const Color(0xFF064E3B); // Emerald Deep – design system
  }

  static String toArabicNumber(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var numStr = number.toString();
    for (var i = 0; i < english.length; i++) {
      numStr = numStr.replaceAll(english[i], arabic[i]);
    }
    return numStr;
  }

  static List<TextSpan> buildTajweedSpans(String text, QuranThemeMode mode) {
    final spans = <TextSpan>[];
    final exp = RegExp(r'\[([a-zA-Z0-9:]+)\[([^\]]+)\]');
    var lastIndex = 0;

    for (final Match m in exp.allMatches(text)) {
      if (m.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, m.start)));
      }

      final rule = m.group(1)!;
      final tajweedText = m.group(2)!;
      final textColor = getTajweedColor(rule, mode);

      spans.add(TextSpan(
        text: tajweedText,
        style: TextStyle(color: textColor),
      ));

      lastIndex = m.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }

  static Color getTajweedColor(String rule, QuranThemeMode mode) {
    final isDark = mode == QuranThemeMode.dark;
    
    if (rule.startsWith('h') ||
        rule.startsWith('s') ||
        rule.startsWith('l') ||
        rule.startsWith('w')) {
      return isDark ? Colors.grey[600]! : Colors.grey[400]!;
    } else if (rule.startsWith('g') || rule.startsWith('f')) {
      return Colors.green;
    } else if (rule.startsWith('m')) {
      return Colors.red;
    } else if (rule.startsWith('o')) {
      return Colors.red[900]!;
    } else if (rule.startsWith('q')) {
      return Colors.blue;
    } else if (rule.startsWith('c')) {
      return Colors.purple;
    } else if (rule.startsWith('p')) {
      return Colors.green[700]!;
    }
    return getTextColor(mode);
  }
}
