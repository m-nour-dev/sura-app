import 'package:sila_app/features/hifz/data/models/hifz_user_profile.dart';

class HifzDailyPlan {

  const HifzDailyPlan({
    required this.newAyahsTarget,
    required this.reviewAyahsTarget,
    required this.estimatedCompletion,
  });
  final int newAyahsTarget;
  final int reviewAyahsTarget;
  final String estimatedCompletion;
}

class PlanGenerator {
  static HifzDailyPlan generate(HifzUserProfile profile) {
    final (newAyahs, reviewAyahs) = _targetsByMinutes(profile.dailyMinutes);
    final targetAyahs = _goalTargetAyahs(profile.goal);

    final days = (targetAyahs / newAyahs).ceil();
    final months = (days / 30).ceil().clamp(1, 999);
    final monthsArabic = _toArabicIndic(months);

    final goalLabel = switch (profile.goal) {
      0 => 'السور القصيرة',
      1 => 'الجزء',
      2 => 'خطة المراجعة',
      3 => 'القرآن كاملاً',
      _ => 'هدفك',
    };

    final estimate = 'ستنهي $goalLabel في $monthsArabic أشهر';

    return HifzDailyPlan(
      newAyahsTarget: newAyahs,
      reviewAyahsTarget: reviewAyahs,
      estimatedCompletion: estimate,
    );
  }

  static (int, int) _targetsByMinutes(int dailyMinutes) {
    return switch (dailyMinutes) {
      10 => (2, 5),
      20 => (3, 8),
      30 => (5, 10),
      60 => (8, 15),
      _ => (3, 8),
    };
  }

  static int _goalTargetAyahs(int goal) {
    return switch (goal) {
      0 => 60,
      1 => 148,
      2 => 286,
      3 => 6236,
      _ => 148,
    };
  }

  static String _toArabicIndic(int value) {
    final western = value.toString();
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final buffer = StringBuffer();

    for (final unit in western.codeUnits) {
      final digit = unit - 48;
      if (digit >= 0 && digit <= 9) {
        buffer.write(digits[digit]);
      }
    }

    return buffer.toString();
  }
}
