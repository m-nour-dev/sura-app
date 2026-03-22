enum HifzSelectionType {
  fullSurah,
  ayahRange,
  dailyPlan,
}

class HifzSelection {
  final int surahNumber;
  final int fromVerse;
  final int toVerse;
  final HifzSelectionType type;

  const HifzSelection({
    required this.surahNumber,
    required this.fromVerse,
    required this.toVerse,
    required this.type,
  });
}
