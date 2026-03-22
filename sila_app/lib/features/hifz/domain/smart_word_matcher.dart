import 'dart:math';

import 'package:sila_app/features/hifz/data/models/hifz_settings.dart';
import 'package:sila_app/features/tasmi/domain/tajweed_normalizer.dart';

enum HifzWordMatchResult {
  correct,
  partialCorrect,
  fuzzyCorrect,
  incorrect,
}

class HifzMatchResult {
  final List<HifzWordMatchResult> wordResults;

  const HifzMatchResult({required this.wordResults});

  bool get allCorrect =>
      wordResults.every((r) => r != HifzWordMatchResult.incorrect);

  int get correctCount =>
      wordResults.where((r) => r != HifzWordMatchResult.incorrect).length;

  int get wrongCount =>
      wordResults.where((r) => r == HifzWordMatchResult.incorrect).length;
}

class SmartWordMatcher {
  static HifzMatchResult matchHiddenWords({
    required String spokenText,
    required List<String> hiddenWords,
    required HifzVerificationMode mode,
    bool ignoreDiacritics = true,
  }) {
    final normalizedSpoken = TajweedNormalizer.normalizeForComparison(
      spokenText,
      ignoreDiacritics: ignoreDiacritics,
    );
    final spokenWords = normalizedSpoken
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList(growable: false);

    final results = <HifzWordMatchResult>[];

    final strictMinSimilarity = switch (mode) {
      HifzVerificationMode.easy => 0.80,
      HifzVerificationMode.normal => 0.86,
      HifzVerificationMode.strict => 0.93,
    };

    for (final hidden in hiddenWords) {
      final normalizedHidden = TajweedNormalizer.normalizeForComparison(
        hidden,
        ignoreDiacritics: ignoreDiacritics,
      );

      if (normalizedHidden.isEmpty) {
        results.add(HifzWordMatchResult.correct);
        continue;
      }

      final exactMatch = spokenWords.any(
        (spokenWord) => TajweedNormalizer.compareWithMode(
          spoken: spokenWord,
          expected: normalizedHidden,
          ignoreDiacritics: false,
          minSimilarity: 1.0,
        ),
      );

      if (exactMatch) {
        results.add(HifzWordMatchResult.correct);
        continue;
      }

      if (spokenWords.any(
        (w) => w.contains(normalizedHidden) || normalizedHidden.contains(w),
      )) {
        results.add(HifzWordMatchResult.partialCorrect);
        continue;
      }

      if (mode != HifzVerificationMode.strict) {
        final bestSimilarity = spokenWords.isEmpty
            ? 0.0
            : spokenWords
                .map((w) => similarity(w, normalizedHidden))
                .fold<double>(0.0, (maxV, s) => s > maxV ? s : maxV);

        if (bestSimilarity >= strictMinSimilarity) {
          results.add(HifzWordMatchResult.fuzzyCorrect);
          continue;
        }
      }

      results.add(HifzWordMatchResult.incorrect);
    }

    return HifzMatchResult(wordResults: results);
  }

  static double similarity(String a, String b) {
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final maxLen = max(a.length, b.length);
    final distance = _levenshtein(a, b);
    return 1.0 - (distance / maxLen);
  }

  static int _levenshtein(String a, String b) {
    final m = a.length;
    final n = b.length;

    final dp = List.generate(m + 1, (i) => List.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          final insert = dp[i][j - 1] + 1;
          final delete = dp[i - 1][j] + 1;
          final replace = dp[i - 1][j - 1] + 1;
          dp[i][j] = min(insert, min(delete, replace));
        }
      }
    }

    return dp[m][n];
  }
}
