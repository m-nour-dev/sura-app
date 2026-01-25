import 'package:adhan/adhan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/features/prayers/data/repositories/prayer_repository_impl.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';

part 'prayer_controller.g.dart';

@riverpod
PrayerRepository prayerRepository(PrayerRepositoryRef ref) {
  return PrayerRepository();
}

@riverpod
class PrayerTimesController extends _$PrayerTimesController {
  @override
  FutureOr<PrayerTimesEntity> build() async {
    final repository = ref.watch(prayerRepositoryProvider);
    return await repository.getPrayerTimes();
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
