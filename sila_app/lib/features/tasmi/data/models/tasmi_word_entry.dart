
// Defines the state of a single word in the recitation view.
enum WordEntryStatus { hidden, correct, closeError, wrongWord }

class TasmiWordEntry {
  final int verseNumber;
  final String word; // The original word with full tashkeel
  WordEntryStatus status;

  TasmiWordEntry({
    required this.verseNumber,
    required this.word,
    this.status = WordEntryStatus.hidden,
  });
}
