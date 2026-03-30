class IbadahContent {

  const IbadahContent({
    required this.id,
    required this.type,
    required this.arabicText,
    required this.shortText,
    required this.source,
    required this.grade,
    this.scholar,
    this.surahNumber,
    this.ayahNumber,
  });

  factory IbadahContent.fromMap(Map<String, dynamic> map) {
    final rawText = (map['arabic_text'] ?? '').toString().trim();
    final short = (map['short_explanation'] ?? '').toString().trim();
    return IbadahContent(
      id: (map['id'] ?? '').toString(),
      type: (map['type'] ?? 'hikma').toString(),
      arabicText: rawText,
      shortText: short.isNotEmpty ? short : _compact(rawText),
      source: (map['source'] ?? '').toString(),
      grade: (map['grade'] ?? '').toString(),
      scholar: map['scholar']?.toString(),
      surahNumber: map['surah_number'] as int?,
      ayahNumber: map['ayah_number'] as int?,
    );
  }
  final String id;
  final String type;
  final String arabicText;
  final String shortText;
  final String source;
  final String grade;
  final String? scholar;
  final int? surahNumber;
  final int? ayahNumber;

  static String _compact(String text) {
    if (text.length <= 170) return text;
    return '${text.substring(0, 170)}...';
  }
}
