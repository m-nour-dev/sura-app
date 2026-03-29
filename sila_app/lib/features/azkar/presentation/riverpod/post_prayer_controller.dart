import 'package:adhan/adhan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:sila_app/core/providers/time_provider.dart';

part 'post_prayer_controller.g.dart';

@riverpod
class PostPrayerVisibility extends _$PostPrayerVisibility {
  @override
  bool build() {
    final prayerTimesAsync = ref.watch(prayerTimesControllerProvider);
    
    return prayerTimesAsync.maybeWhen(
      data: (prayerTimes) {
        final now = ref.watch(timeTickProvider).value ?? DateTime.now();
        // Check 45-minute window for each prayer
        final prayers = [
          prayerTimes.fajr,
          prayerTimes.dhuhr,
          prayerTimes.asr,
          prayerTimes.maghrib,
          prayerTimes.isha,
        ];

        const window = Duration(minutes: 45);

        for (final prayerTime in prayers) {
          final diff = now.difference(prayerTime);
          if (diff >= Duration.zero && diff <= window) {
            return true;
          }
        }
        return false;
      },
      orElse: () => false,
    );
  }
}

@riverpod
String? currentPostPrayerName(CurrentPostPrayerNameRef ref) {
  final prayerTimesAsync = ref.watch(prayerTimesControllerProvider);
  
  return prayerTimesAsync.maybeWhen(
    data: (prayerTimes) {
      final now = ref.watch(timeTickProvider).value ?? DateTime.now();
      const window = Duration(minutes: 45);
      
      if (now.difference(prayerTimes.fajr) >= Duration.zero && now.difference(prayerTimes.fajr) <= window) return 'fajr';
      if (now.difference(prayerTimes.dhuhr) >= Duration.zero && now.difference(prayerTimes.dhuhr) <= window) return 'dhuhr';
      if (now.difference(prayerTimes.asr) >= Duration.zero && now.difference(prayerTimes.asr) <= window) return 'asr';
      if (now.difference(prayerTimes.maghrib) >= Duration.zero && now.difference(prayerTimes.maghrib) <= window) return 'maghrib';
      if (now.difference(prayerTimes.isha) >= Duration.zero && now.difference(prayerTimes.isha) <= window) return 'isha';
      
      return null;
    },
    orElse: () => null,
  );
}
