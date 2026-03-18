
import 'dart:math';

enum WordMatchResult { correct, closeError, wrongWord }

class TajweedNormalizer {
  /// Strips Quranic annotations, diacritics (tashkeel), and tatweel from text.
  static String normalize(String text) {
    // Strip:
    // - Quran annotations (U+0610 to U+061A)
    // - Tashkeel / Diacritics (U+064B to U+065F)
    // - Tatweel (U+0640)
    final pattern = RegExp(r'[ؐ-ًؚ-ٟـ]');
    String normalized = text.replaceAll(pattern, '');

    // Replace specific Arabic letters with their base form for broader matching.
    // Replace أ, إ, آ with ا
    normalized = normalized.replaceAll(RegExp(r'[أإآ]'), 'ا');
    // Replace ة with ه
    normalized = normalized.replaceAll('ة', 'ه');
    // Replace ى with ي
    normalized = normalized.replaceAll('ى', 'ي');

    // Trim and remove extra whitespace
    return normalized.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Compares a spoken word against the expected Quranic word.
  static WordMatchResult compareWord({
    required String spoken,
    required String expected,
  }) {
    final normalizedSpoken = normalize(spoken);
    final normalizedExpected = normalize(expected);

    if (normalizedSpoken == normalizedExpected) {
      return WordMatchResult.correct;
    }

    final similarityScore = _similarity(normalizedSpoken, normalizedExpected);

    if (similarityScore >= 0.75) {
      return WordMatchResult.closeError;
    } else {
      return WordMatchResult.wrongWord;
    }
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
