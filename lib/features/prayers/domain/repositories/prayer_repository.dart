import 'package:adhan/adhan.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';

/// Abstract repository interface for prayer times
abstract class PrayerRepository {
  /// Get prayer times for the current location
  Future<PrayerTimesEntity> getPrayerTimes();

  /// Get the next prayer
  Future<Prayer> getNextPrayer();
}
