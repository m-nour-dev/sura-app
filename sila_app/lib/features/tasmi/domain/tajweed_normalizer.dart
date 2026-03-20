
import 'dart:math';
import 'package:sila_app/features/tasmi/data/models/tasmi_preferences.dart';

enum WordMatchResult { correct, closeError, wrongWord }

class TajweedNormalizer {
  static String normalize(String text) {
    String result = text;

    result = result.replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '');
    result = result.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    result = result.replaceAll('ة', 'ه');
    result = result.replaceAll('ؤ', 'و');
    result = result.replaceAll('ئ', 'ي');

    result = result.replaceAll('اا', 'ا');

    result = result.replaceAll(RegExp(r'[۩﴿﴾ۖۗۘۙۚۛۜ۞]'), '');
    result = result.replaceAll(RegExp(r'\s+'), ' ');

    return result.trim();
  }

  /// Compares a spoken word against the expected Quranic word.
  static WordMatchResult compareWord({
    required String spoken,
    required String expected,
    StrictnessLevel strictness = StrictnessLevel.medium,
  }) {
    final normalizedSpoken = normalize(spoken);
    final normalizedExpected = normalize(expected);

    if (normalizedSpoken == normalizedExpected) {
      return WordMatchResult.correct;
    }

    final similarityScore = _similarity(normalizedSpoken, normalizedExpected);

    final correctThreshold = switch (strictness) {
      StrictnessLevel.easy => 0.90,
      StrictnessLevel.medium => 0.95,
      StrictnessLevel.strict => 0.98,
    };

    final closeThreshold = switch (strictness) {
      StrictnessLevel.easy => 0.70,
      StrictnessLevel.medium => 0.75,
      StrictnessLevel.strict => 0.85,
    };

    if (strictness == StrictnessLevel.easy && similarityScore >= closeThreshold) {
      return WordMatchResult.correct;
    }

    if (similarityScore >= correctThreshold) {
      return WordMatchResult.correct;
    }

    if (similarityScore >= closeThreshold) {
      return WordMatchResult.closeError;
    }

    return WordMatchResult.wrongWord;
  }

  /// Calculates the Levenshtein similarity between two strings, from 0.0 to 1.0.
  static double _similarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final distance = _levenshteinDistance(a, b);
    final maxLength = max(a.length, b.length);
    return 1.0 - (distance / maxLength);
  }

  /// Standard Levenshtein distance algorithm.
  static int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> v0 = List<int>.generate(s2.length + 1, (i) => i, growable: false);
    List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < s2.length; j++) {
        int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }

      for (int j = 0; j < s2.length + 1; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[s2.length];
  }
}
