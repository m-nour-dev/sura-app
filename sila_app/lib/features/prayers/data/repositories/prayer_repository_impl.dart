import 'package:adhan/adhan.dart';
import 'package:sila_app/core/services/location_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/core/services/timezone_service.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';
import 'package:sila_app/features/prayers/domain/repositories/prayer_repository.dart';

class PrayerRepositoryImpl extends PrayerRepository {
  // Default Location: Istanbul, Turkey (fallback)
  static const double _defaultLat = 41.0082;
  static const double _defaultLong = 28.9784;

  Future<PrayerTimesEntity> getPrayerTimes() async {
    // Initialize services
    final locService = LocationService();
    final prefs = PrefsService();
    final timezoneService = TimezoneService();
    
    // Ensure timezone service is initialized
    await timezoneService.initialize();

    // Default values
    double lat = _defaultLat;
    double long = _defaultLong;
    String city = "İstanbul, Türkiye";

    // Get location coordinates
    try {
      final isAuto = await prefs.isAutoLocation();

      if (isAuto) {
        final position = await locService.determinePosition();
        lat = position.latitude;
        long = position.longitude;
        city = await locService.getCityFromCoordinates(lat, long);
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

    // Get timezone for the location
    final timezoneName = timezoneService.getTimezoneFromCoordinates(lat, long);
    print("Prayer times timezone: $timezoneName for coordinates: $lat, $long");

    // Get calculation method from preferences
    final methodString = await prefs.getCalculationMethod();
    final params = _getCalculationParams(methodString);
    
    // Create coordinates and date
    final myCoordinates = Coordinates(lat, long);
    final date = DateComponents.from(DateTime.now());
    
    // Get timezone offset for the location
    final tzLocation = timezoneService.getLocation(timezoneName);
    final locationNow = tzLocation != null 
        ? timezoneService.getCurrentTimeInTimezone(timezoneName)
        : DateTime.now();
    final utcOffset = locationNow.timeZoneOffset;
    
    print("Location timezone offset: $utcOffset");
    
    // Calculate prayer times using location timezone
    final prayerTimes = PrayerTimes(myCoordinates, date, params, utcOffset: utcOffset);
    
    return PrayerTimesEntity(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      locationName: city,
      latitude: lat,
      longitude: long,
      timezoneName: timezoneName,
    );
  }
  
  /// Get calculation parameters based on method string
  CalculationParameters _getCalculationParams(String method) {
    CalculationParameters params;
    
    switch (method.toLowerCase()) {
      case 'muslim_world_league':
        params = CalculationMethod.muslim_world_league.getParameters();
        break;
      case 'egyptian':
        params = CalculationMethod.egyptian.getParameters();
        break;
      case 'karachi':
        params = CalculationMethod.karachi.getParameters();
        break;
      case 'umm_al_qura':
        params = CalculationMethod.umm_al_qura.getParameters();
        break;
      case 'dubai':
        params = CalculationMethod.dubai.getParameters();
        break;
      case 'qatar':
        params = CalculationMethod.qatar.getParameters();
        break;
      case 'kuwait':
        params = CalculationMethod.kuwait.getParameters();
        break;
      case 'singapore':
        params = CalculationMethod.singapore.getParameters();
        break;
      case 'north_america':
        params = CalculationMethod.north_america.getParameters();
        break;
      case 'turkey':
      default:
        params = CalculationMethod.turkey.getParameters();
    }
    
    // Set madhab to Shafi (can be made configurable later)
    params.madhab = Madhab.shafi;
    
    return params;
  }
  
  /// Get next prayer using actual location coordinates
  Future<Prayer> getNextPrayer() async {
    final prefs = PrefsService();
    final locService = LocationService();
    
    // Get actual location (same logic as getPrayerTimes)
    double lat = _defaultLat;
    double long = _defaultLong;

    try {
      final isAuto = await prefs.isAutoLocation();

      if (isAuto) {
        final position = await locService.determinePosition();
        lat = position.latitude;
        long = position.longitude;
      } else {
        final stored = await prefs.getStoredLocation();
        if (stored != null) {
          lat = stored["lat"];
          long = stored["long"];
        }
      }
    } catch (e) {
      print("Location Error in getNextPrayer: $e");
    }

    // Get calculation method
    final methodString = await prefs.getCalculationMethod();
    final params = _getCalculationParams(methodString);
    
    final myCoordinates = Coordinates(lat, long);
    final date = DateComponents.from(DateTime.now());
    final prayerTimes = PrayerTimes(myCoordinates, date, params);
    
    return prayerTimes.nextPrayer();
  }
}
