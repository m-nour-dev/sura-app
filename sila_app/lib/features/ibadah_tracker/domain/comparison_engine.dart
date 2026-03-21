import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_record.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_calculator.dart';

class ComparisonEngine {
  bool isTodayBetter({
    required IbadahRecord today,
    required IbadahRecord yesterday,
    required bool isMale,
  }) {
    return DailyStatusCalculator.completionRatio(today, isMale: isMale) >
        DailyStatusCalculator.completionRatio(yesterday, isMale: isMale);
  }

  String comparisonText({
    required IbadahRecord today,
    required IbadahRecord yesterday,
    required bool isMale,
  }) {
    final todayRatio =
        DailyStatusCalculator.completionRatio(today, isMale: isMale);
    final yesterdayRatio =
        DailyStatusCalculator.completionRatio(yesterday, isMale: isMale);
    if (todayRatio > yesterdayRatio)
      return 'أنت أفضل من أمس — بارك الله فيك 🌟';
    if (todayRatio == yesterdayRatio)
      return 'ثبات جميل — الاستمرار هو سر التميز 🌿';
    return 'فرصة جديدة غدًا — والله يعينك على الأحسن 🌅';
  }
}
