import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/features/prayers/data/repositories/prayer_repository_impl.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';

part 'prayer_controller.g.dart';

@Riverpod(keepAlive: true)
PrayerRepositoryImpl prayerRepository(PrayerRepositoryRef ref) {
  return PrayerRepositoryImpl();
}

@Riverpod(keepAlive: true)
class PrayerTimesController extends _$PrayerTimesController {
  static const _ttl = Duration(minutes: 20);

  @override
  FutureOr<PrayerTimesEntity> build() async {
    final timer = Timer.periodic(_ttl, (_) {
      final repository = ref.read(prayerRepositoryProvider);
      if (repository.isPrayerCacheStale()) {
        ref.invalidateSelf();
      }
    });
    ref.onDispose(timer.cancel);

    final repository = ref.watch(prayerRepositoryProvider);
    return await repository.getPrayerTimes();
  }

  Future<void> refreshIfStale() async {
    final repository = ref.read(prayerRepositoryProvider);
    if (repository.isPrayerCacheStale()) {
      ref.invalidateSelf();
      await future;
    }
  }

  Future<void> forceRefresh() async {
    final repository = ref.read(prayerRepositoryProvider);
    repository.clearCache();
    ref.invalidateSelf();
    await future;
  }
}

@Riverpod(keepAlive: true)
class NextPrayerController extends _$NextPrayerController {
  @override
  FutureOr<Prayer> build() async {
    final repository = ref.watch(prayerRepositoryProvider);
    return await repository.getNextPrayer();
  }

  Future<void> refreshFromPrayerTimes() async {
    await ref.read(prayerTimesControllerProvider.notifier).refreshIfStale();
    ref.invalidateSelf();
    await future;
  }
}
