import 'package:flutter_test/flutter_test.dart';
import 'package:sura_app/features/hifz/domain/spaced_repetition_engine.dart';

void main() {
  group('SpacedRepetitionEngine.calculateNext', () {
    test('quality=5 increases interval and keeps EF high', () {
      final result = SpacedRepetitionEngine.calculateNext(
        currentIntervalDays: 6,
        easinessFactor: 2.5,
        quality: 5,
      );

      expect(result.nextIntervalDays, greaterThan(6));
      expect(result.newEasinessFactor, closeTo(2.6, 0.0001));
      expect(result.nextReviewDate.isAfter(DateTime.now()), isTrue);
    });

    test('quality=3 increases interval moderately', () {
      final result = SpacedRepetitionEngine.calculateNext(
        currentIntervalDays: 6,
        easinessFactor: 2.5,
        quality: 3,
      );

      expect(result.newEasinessFactor, closeTo(2.36, 0.0001));
      expect(result.nextIntervalDays, 14);
      expect(result.nextReviewDate.isAfter(DateTime.now()), isTrue);
    });

    test('quality=1 resets interval to 1 and decreases EF', () {
      final result = SpacedRepetitionEngine.calculateNext(
        currentIntervalDays: 14,
        easinessFactor: 2.5,
        quality: 1,
      );

      expect(result.nextIntervalDays, 1);
      expect(result.newEasinessFactor, closeTo(1.96, 0.0001));
      expect(result.nextReviewDate.isAfter(DateTime.now()), isTrue);
    });
  });
}

