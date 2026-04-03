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
  @override
  FutureOr<PrayerTimesEntity> build() async {
    final repository = ref.watch(prayerRepositoryProvider);
    final ttl = repository.prayerTimesCacheTtl;
    final timer = Timer.periodic(ttl, (_) {
      final repository = ref.read(prayerRepositoryProvider);
      if (repository.isPrayerCacheStale()) {
        ref.invalidateSelf();
      }
    });
    ref.onDispose(timer.cancel);

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
    ref.invalidate(nextPrayerControllerProvider);
    ref.invalidateSelf();
    await future;
  }
}

@Riverpod(keepAlive: true)
class NextPrayerController extends _$NextPrayerController {
  Timer? _nextPrayerBoundaryTimer;

  @override
  FutureOr<Prayer> build() async {
    ref.onDispose(() => _nextPrayerBoundaryTimer?.cancel());

    final prayerTimes = await ref.watch(prayerTimesControllerProvider.future);
    final repository = ref.watch(prayerRepositoryProvider);
    final nextPrayer = await repository.getNextPrayer();
    _scheduleBoundaryRefresh(prayerTimes, nextPrayer);
    return nextPrayer;
  }

  Future<void> refreshFromPrayerTimes() async {
    await ref.read(prayerTimesControllerProvider.notifier).refreshIfStale();
    ref.invalidateSelf();
    await future;
  }

  void _scheduleBoundaryRefresh(PrayerTimesEntity entity, Prayer nextPrayer) {
    _nextPrayerBoundaryTimer?.cancel();

    final now = DateTime.now();
    var boundary = _boundaryForPrayer(entity, nextPrayer);
    if (!boundary.isAfter(now)) {
      boundary = boundary.add(const Duration(days: 1));
    }

    var delay = boundary.difference(now) + const Duration(seconds: 1);
    if (delay.isNegative || delay == Duration.zero) {
      delay = const Duration(seconds: 1);
    }

    _nextPrayerBoundaryTimer = Timer(delay, () {
      ref.invalidateSelf();
    });
  }

  DateTime _boundaryForPrayer(PrayerTimesEntity entity, Prayer prayer) {
    return switch (prayer) {
      Prayer.fajr => entity.fajr,
      Prayer.sunrise => entity.sunrise,
      Prayer.dhuhr => entity.dhuhr,
      Prayer.asr => entity.asr,
      Prayer.maghrib => entity.maghrib,
      Prayer.isha => entity.isha,
      _ => entity.fajr.add(const Duration(days: 1)),
    };
  }
}
