import 'package:adhan/adhan.dart';
import 'package:sila_app/core/services/adhan_scheduler_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/features/prayers/data/repositories/prayer_repository_impl.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';

part 'prayer_controller.g.dart';

@riverpod
PrayerRepositoryImpl prayerRepository(PrayerRepositoryRef ref) {
  return PrayerRepositoryImpl();
}

@riverpod
class PrayerTimesController extends _$PrayerTimesController {
  @override
  FutureOr<PrayerTimesEntity> build() async {
    final repository = ref.watch(prayerRepositoryProvider);
    final times = await repository.getPrayerTimes();
    
    // Automatically schedule adhans whenever times are refreshed
    try {
      await AdhanSchedulerService().scheduleAllPrayers(times);
    } catch (e) {
      print('Failed to schedule adhan: $e');
    }
    
    return times;
  }
}

@riverpod
class NextPrayerController extends _$NextPrayerController {
  @override
  FutureOr<Prayer> build() async {
    final repository = ref.watch(prayerRepositoryProvider);
    // Refresh every minute to keep 'Next' updated? 
    // For now, just fetch once.
    return await repository.getNextPrayer();
  }
}
