import 'package:isar/isar.dart';

part 'wird_settings.g.dart';

@collection
class WirdSettings {
  Id id = Isar.autoIncrement;

  // Current page the user is at (Last read page)
  // Default starts at page 0 (before Fatiha) or 1
  int currentPage = 1;

  // How many pages per day the user wants to read
  int pagesPerDay = 2;

  // The last date the user completed their wird.
  // Useful to check if "today's task" is done.
  DateTime? lastCompletionDate;

  // Start date of the current Khatma
  DateTime? khatmaStartDate;

  // Total pages in Quran (Standard Madani)
  static const int totalQuranPages = 604;

  // Helper to calculate target page for today
  int get targetPageForToday {
    // If completed today, target is same as current (done)
    // If not, target is currentPage + pagesPerDay
    // We handle the logic in controller mainly, but this is a model property
    return (currentPage + pagesPerDay) > totalQuranPages 
        ? totalQuranPages 
        : currentPage + pagesPerDay;
  }
}
