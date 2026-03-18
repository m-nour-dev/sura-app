
import 'package:isar/isar.dart';

part 'tasmi_word_error.g.dart';

@collection
class TasmiWordError {
  Id id = Isar.autoIncrement;

  late int surahIndex;
  late int verseNumber;
  late String correctWord;
  late String spokenWord;
  late int errorTypeIndex; // Corresponds to WordMatchResult.index
  late DateTime timestamp;
}
