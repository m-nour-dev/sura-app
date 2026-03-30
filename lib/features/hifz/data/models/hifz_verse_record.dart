import 'package:isar/isar.dart';

part 'hifz_verse_record.g.dart';

@collection
class HifzVerseRecord {
  Id id = Isar.autoIncrement;

  late int surahIndex;
  late int verseNumber;
  late int intervalDays;
  late double easinessFactor;
  late DateTime nextReviewDate;
  late DateTime lastReviewDate;
  late int totalSessions;
  late int correctSessions;
  late String lastMethodUsed;
}
