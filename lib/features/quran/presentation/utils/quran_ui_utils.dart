import 'package:flutter/material.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';

class QuranUIUtils {
  static Color getBackgroundColor(QuranThemeMode mode) {
    if (mode == QuranThemeMode.dark) return const Color(0xFF0F172A); // Night Deep
    if (mode == QuranThemeMode.sepia) return const Color(0xFFF5EDD8); // Warm Parchment
    return const Color(0xFFFDFBF7); // Parchment – design system
  }

  static Color getTextColor(QuranThemeMode mode) {
    if (mode == QuranThemeMode.dark) return const Color(0xFFE8EEF4);
    if (mode == QuranThemeMode.sepia) return const Color(0xFF3D2B1F);
    return const Color(0xFF0F172A); // Night Deep – design system
  }

  static Color getAccentColor(QuranThemeMode mode) {
    if (mode == QuranThemeMode.dark) return const Color(0xFFD97706); // Islamic Gold
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

  static List<TextSpan> buildTajweedSpans(String text, QuranThemeMode mode, {TextStyle? baseStyle}) {
    final spans = <TextSpan>[];
    final exp = RegExp(r'\[([a-zA-Z0-9:]+)\[([^\]]+)\]');
    var lastIndex = 0;

    final defaultStyle = baseStyle ?? TextStyle(color: getTextColor(mode));

    for (final Match m in exp.allMatches(text)) {
      if (m.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, m.start),
          style: defaultStyle,
        ));
      }

      final rule = m.group(1)!;
      final tajweedText = m.group(2)!;
      final ruleColor = getTajweedColor(rule, mode);

      spans.add(TextSpan(
        text: tajweedText,
        style: defaultStyle.copyWith(color: ruleColor),
      ));

      lastIndex = m.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: defaultStyle,
      ));
    }

    return spans;
  }

  static Color getTajweedColor(String rule, QuranThemeMode mode) {
    final isDark = mode == QuranThemeMode.dark;
    
    // Professional Tajweed palette inspired by Dar Al-Maarifah
    if (rule.startsWith('m')) {
      return isDark ? const Color(0xFFFF5252) : const Color(0xFFD32F2F); // Madd (Red)
    } else if (rule.startsWith('o')) {
      return isDark ? const Color(0xFFFF1744) : const Color(0xFFB71C1C); // Obligatory Madd (Darker Red)
    } else if (rule.startsWith('g')) {
      return isDark ? const Color(0xFF69F0AE) : const Color(0xFF2E7D32); // Ghunnah (Green)
    } else if (rule.startsWith('f')) {
      return isDark ? const Color(0xFFB9F6CA) : const Color(0xFF43A047); // Ikhfa (Lighter Green)
    } else if (rule.startsWith('q')) {
      return isDark ? const Color(0xFF40C4FF) : const Color(0xFF1976D2); // Qalqalah (Blue)
    } else if (rule.startsWith('p')) {
      return isDark ? const Color(0xFFFFD180) : const Color(0xFFE65100); // Qalb (Orange/Amber)
    } else if (rule.startsWith('c')) {
      return isDark ? const Color(0xFFEA80FC) : const Color(0xFF8E24AA); // Ikhfa Meem Saakin (Purple/Pink)
    } else if (rule.startsWith('h') ||
        rule.startsWith('s') ||
        rule.startsWith('l') ||
        rule.startsWith('w')) {
      return isDark ? Colors.white24 : Colors.black26; // Silent letters (Faded Grey)
    }
    
    return getTextColor(mode);
  }
}
