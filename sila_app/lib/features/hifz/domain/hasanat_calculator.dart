class HasanatCalculator {
  static int countChars(String arabicText) {
    var count = 0;
    for (final rune in arabicText.runes) {
      if (_isArabicRune(rune)) {
        count++;
      }
    }
    return count;
  }

  static int calculate(String arabicText) {
    return countChars(arabicText) * 10;
  }

  static String formatHasanat(int count) {
    return '${_toArabicIndic(count)} حسنة بإذن الله';
  }

  static bool _isArabicRune(int rune) {
    return (rune >= 0x0600 && rune <= 0x06FF) ||
        (rune >= 0x0750 && rune <= 0x077F) ||
        (rune >= 0x08A0 && rune <= 0x08FF) ||
        (rune >= 0xFB50 && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF);
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
