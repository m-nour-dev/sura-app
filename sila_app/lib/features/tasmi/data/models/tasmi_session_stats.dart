
import 'package:equatable/equatable.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_error.dart';

class TasmiSessionStats extends Equatable {

  const TasmiSessionStats({
    required this.correctCount,
    required this.closeErrorCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.errorList,
  });

  factory TasmiSessionStats.initial() => const TasmiSessionStats(
        correctCount: 0,
        closeErrorCount: 0,
        wrongCount: 0,
        skippedCount: 0,
        errorList: [],
      );
  final int correctCount;
  final int closeErrorCount;
  final int wrongCount;
  final int skippedCount;
  final List<TasmiWordError> errorList;

  int get totalErrors => closeErrorCount + wrongCount;

  int get errorCount => totalErrors;

  List<TasmiWordError> get errors => errorList;

  double get accuracyPercent {
    final total = correctCount + totalErrors;
    if (total == 0) return 100;
    return (correctCount / total) * 100;
  }

  @override
  List<Object?> get props => [
        correctCount,
        closeErrorCount,
        wrongCount,
        skippedCount,
        errorList,
      ];
}
