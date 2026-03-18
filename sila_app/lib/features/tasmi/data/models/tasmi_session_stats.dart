
import 'package:sila_app/features/tasmi/data/models/tasmi_word_error.dart';

class TasmiSessionStats {
  final int correctCount;
  final int errorCount;
  final List<TasmiWordError> errors;

  TasmiSessionStats({
    required this.correctCount,
    required this.errorCount,
    required this.errors,
  });

  factory TasmiSessionStats.initial() {
    return TasmiSessionStats(
      correctCount: 0,
      errorCount: 0,
      errors: [],
    );
  }
}
