import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_record.dart';
import 'package:sila_app/features/ibadah_tracker/presentation/controllers/ibadah_tracker_controller.dart';

class DailyReportState {
  const DailyReportState(
      {required this.today, required this.yesterday, required this.isMale});
  final IbadahRecord today;
  final IbadahRecord? yesterday;
  final bool isMale;
}

final dailyReportProvider = Provider<AsyncValue<DailyReportState>>((ref) {
  final tracker = ref.watch(ibadahTrackerControllerProvider);
  return tracker.whenData(
    (value) => DailyReportState(
        today: value.today, yesterday: value.yesterday, isMale: value.isMale),
  );
});

final firstRecordDateProvider = FutureProvider<DateTime?>((ref) async {
  final repo = await ref.watch(ibadahRepositoryProvider.future);
  return repo.getFirstRecordDate();
});

final recordsRangeProvider =
    FutureProvider.family<List<IbadahRecord>, ({DateTime start, DateTime end})>(
        (ref, range) async {
  final repo = await ref.watch(ibadahRepositoryProvider.future);
  return repo.getRecordsInRange(start: range.start, end: range.end);
});
