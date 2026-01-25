import 'package:adhan/adhan.dart';
import 'package:sila_app/core/services/location_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';

class PrayerRepository {
  // Mock Location: Istanbul, Turkey
  static const double _lat = 41.0082;
  static const double _long = 28.9784;

  Future<PrayerTimesEntity> getPrayerTimes() async {
    // Services invocation (Should actully be injected via Riverpod, but for simplicity instantiating here or passing)
    final locService = LocationService();
    final prefs = PrefsService();

    double lat = 41.0082; // Default Istanbul
    double long = 28.9784;
    String city = "İstanbul, Türkiye";

    try {
      final isAuto = await prefs.isAutoLocation();

      if (isAuto) {
        final position = await locService.determinePosition();
        lat = position.latitude;
        long = position.longitude;
        city = await locService.getCityFromCoordinates(lat, long);
        
        // Save these auto coordinates as "last known" implicitly or separate key?
        // For now just use them.
      } else {
        final stored = await prefs.getStoredLocation();
        if (stored != null) {
          lat = stored["lat"];
          long = stored["long"];
          city = stored["city"];
        }
      }
    } catch (e) {
      print("Location Error: $e"); // Fallback to default
    }

    final myCoordinates = Coordinates(lat, long);
    final params = CalculationMethod.turkey.getParameters();
    params.madhab = Madhab.shafi;
    
    final date = DateComponents.from(DateTime.now());
    final prayerTimes = PrayerTimes(myCoordinates, date, params);

    return PrayerTimesEntity(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      locationName: city,
    );
  }
  
  // Method to get next prayer
  Future<Prayer> getNextPrayer() async {
     final myCoordinates = Coordinates(_lat, _long);
    final params = CalculationMethod.turkey.getParameters();
    final date = DateComponents.from(DateTime.now());
    final prayerTimes = PrayerTimes(myCoordinates, date, params);
    return prayerTimes.nextPrayer();
  }
}
