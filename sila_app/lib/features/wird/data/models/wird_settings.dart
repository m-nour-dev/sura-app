import 'package:isar/isar.dart';

part 'wird_settings.g.dart';

enum WirdGoalType { page, juz, hizb }

@collection
class WirdSettings {
  Id id = Isar.autoIncrement;

  // Current page the user is at (Last read page)
  int currentPage = 1;

  // The bookmarked page
  int? bookmarkPage;

  // Goal settings
  @enumerated
  WirdGoalType goalType = WirdGoalType.page;
  int goalValue = 2; // Default 2 pages

  bool hasConfiguredGoal = false;

  // Deprecated: keeping for compatibility during migration if needed
  int pagesPerDay = 2;

  // The last date the user completed their wird.
  DateTime? lastCompletionDate;

  // Start date of the current Khatma
  DateTime? khatmaStartDate;

  // Total pages in Quran (Standard Madani)
  static const int totalQuranPages = 604;

  // Helper to calculate target page for today
  @ignore
  int? _stableTargetPage;

  @ignore
  int get targetPageForToday {
    if (_stableTargetPage != null) return _stableTargetPage!;
    
    var increment = 0;
    switch (goalType) {
      case WirdGoalType.page:
        increment = goalValue;
        break;
      case WirdGoalType.juz:
        increment = goalValue * 20;
        break;
      case WirdGoalType.hizb:
        increment = goalValue * 10;
        break;
    }
    
    return (currentPage + increment).clamp(1, totalQuranPages);
  }

  set targetPageForToday(int value) {
    _stableTargetPage = value;
  }
}
