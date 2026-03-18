
import 'package:flutter_test/flutter_test.dart';
import 'package:sila_app/features/tasmi/domain/tajweed_normalizer.dart';

void main() {
  group('TajweedNormalizer.normalize', () {
    test('should strip all tashkeel', () {
      const withTashkeel = 'الرَّحْمَٰنِ الرَّحِيمِ';
      const expected = 'الرحمن الرحيم';
      expect(TajweedNormalizer.normalize(withTashkeel), expected);
    });

    test('should strip Quranic annotations', () {
      const withAnnotations = 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ ۙ';
      const expected = 'صراط الذين انعمت عليهم';
      expect(TajweedNormalizer.normalize(withAnnotations), expected);
    });

    test('should strip tatweel', () {
      const withTatweel = 'مَالِكِ يَوْمِ الدِّيــــنِ';
      const expected = 'مالك يوم الدين';
      expect(TajweedNormalizer.normalize(withTatweel), expected);
    });

    test('should normalize different forms of alif', () {
      const withAlif = 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ';
      const expected = 'اياك نعبد واياك';
      expect(TajweedNormalizer.normalize(withAlif), expected);
    });

    test('should normalize taa marbutah', () {
      const withTaaMarbutah = 'الْحَاقَّةُ';
      const expected = 'الحاقه';
      expect(TajweedNormalizer.normalize(withTaaMarbutah), expected);
    });
    
    test('should normalize alif maqsura', () {
      const withAlifMaqsura = 'عَلَىٰ';
      const expected = 'على';
      expect(TajweedNormalizer.normalize(withAlifMaqsura), expected);
    });

    test('should handle multiple spaces and trim', () {
      const withSpaces = '  بِسْمِ   اللهِ  ';
      const expected = 'بسم الله';
      expect(TajweedNormalizer.normalize(withSpaces), expected);
    });
  });

  group('TajweedNormalizer.compareWord', () {
    test('should return "correct" for exact match with different tashkeel', () {
      const spoken = 'الرحمن';
      const expected = 'الرَّحْمَٰنِ';
      final result = TajweedNormalizer.compareWord(spoken: spoken, expected: expected);
      expect(result, WordMatchResult.correct);
    });

    test('should return "closeError" for a tajweed mistake (similarity >= 0.75)', () {
      const spokenClose = 'العلمين';
      const expectedClose = 'الْعَالَمِينَ'; // Normalized: العالمين
      final resultClose = TajweedNormalizer.compareWord(spoken: spokenClose, expected: expectedClose);
      expect(resultClose, WordMatchResult.closeError, reason: "Similarity should be high");

    });
    
    test('should return "closeError" for another close mistake', () {
      // "مستقيم" vs "المستقيم"
      const spokenClose2 = 'مستقيم';
      const expectedClose2 = 'الْمُسْتَقِيمَ'; // Normalized: المستقيم
      final resultClose2 = TajweedNormalizer.compareWord(spoken: spokenClose2, expected: expectedClose2);
      expect(resultClose2, WordMatchResult.closeError, reason: "Similarity should be high for missing 'ال'");
    });

    test('should return "wrongWord" for a completely different word (similarity < 0.75)', () {
      const spoken = 'اياك';
      const expected = 'الحمد';
      final result = TajweedNormalizer.compareWord(spoken: spoken, expected: expected);
      expect(result, WordMatchResult.wrongWord);
    });

    test('should return "correct" for words with different alif forms', () {
      const spoken = 'اياك';
      const expected = 'إِيَّاكَ';
      final result = TajweedNormalizer.compareWord(spoken: spoken, expected: expected);
      expect(result, WordMatchResult.correct);
    });
    
    test('should return "correct" for words with taa marbutah vs haa', () {
      const spoken = 'الصلاه';
      const expected = 'الصَّلَاةِ';
      final result = TajweedNormalizer.compareWord(spoken: spoken, expected: expected);
      expect(result, WordMatchResult.correct);
    });
  });
}
