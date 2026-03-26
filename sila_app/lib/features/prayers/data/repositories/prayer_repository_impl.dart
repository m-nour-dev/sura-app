import 'package:adhan/adhan.dart';
import 'package:sila_app/core/services/location_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';
import 'package:sila_app/features/prayers/domain/repositories/prayer_repository.dart';

class PrayerRepositoryImpl extends PrayerRepository {
  // Default Location: Istanbul, Turkey (fallback)
  static const double _defaultLat = 41.0082;
  static const double _defaultLong = 28.9784;
  static const String _defaultCity = 'İstanbul, Türkiye';

  @override
  Future<PrayerTimesEntity> getPrayerTimes() async {
    final locService = LocationService();
    final prefs = PrefsService();

    var lat = _defaultLat;
    var long = _defaultLong;
    var city = _defaultCity;
    var countryCode = 'TR';

    // Get location
    try {
      final isAuto = await prefs.isAutoLocation();
      final oldCountryCode = await prefs.getCountryCode();

      if (isAuto) {
        final position = await locService.determinePosition();
        lat = position.latitude;
        long = position.longitude;
        final locationInfo = await locService.getLocationInfo(lat, long);
        city = locationInfo['city'] ?? _defaultCity;
        countryCode = locationInfo['countryCode'] ?? 'TR';

        // ONLY Auto-select calculation method if the country actually changed
        // This prevents overwriting the user's manual method choice on every reload
        if (oldCountryCode != countryCode) {
          final autoMethod = _getMethodForCountry(countryCode);
          await prefs.setCalculationMethod(autoMethod);
          await prefs.saveCountryCode(countryCode);
        }
      } else {
        final stored = await prefs.getStoredLocation();
        if (stored != null) {
          lat = stored['lat'] as double;
          long = stored['long'] as double;
          city = stored['city'] as String;
          countryCode = stored['countryCode'] as String? ?? 'TR';
          
          if (oldCountryCode != countryCode) {
             final autoMethod = _getMethodForCountry(countryCode);
             await prefs.setCalculationMethod(autoMethod);
             await prefs.saveCountryCode(countryCode);
          }
        }
      }
    } catch (e) {
      print('Location Error: $e');
    }

    // Get calculation method from preferences
    final methodString = await prefs.getCalculationMethod();
    final params = _getCalculationParams(methodString);

    final myCoordinates = Coordinates(lat, long);
    final date = DateComponents.from(DateTime.now());

    // Use the device's local timezone offset — this is the most reliable way
    // to ensure prayer times align with what the user sees on their clock.
    final utcOffset = DateTime.now().timeZoneOffset;

    final prayerTimes = PrayerTimes(
      myCoordinates,
      date,
      params,
      utcOffset: utcOffset,
    );

    // The adhan library with utcOffset returns DateTime objects where:
    //   - isUtc = true  (the kind is UTC)
    //   - but the hour/minute values are already LOCAL (shifted by utcOffset)
    // So we must read the hour/minute/second directly and create a LOCAL DateTime.
    DateTime toLocal(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
    }

    return PrayerTimesEntity(
      fajr: toLocal(prayerTimes.fajr),
      sunrise: toLocal(prayerTimes.sunrise),
      dhuhr: toLocal(prayerTimes.dhuhr),
      asr: toLocal(prayerTimes.asr),
      maghrib: toLocal(prayerTimes.maghrib),
      isha: toLocal(prayerTimes.isha),
      locationName: city,
      latitude: lat,
      longitude: long,
      countryCode: countryCode,
      calculationMethod: methodString,
    );
  }

  @override
  Future<Prayer> getNextPrayer() async {
    final prefs = PrefsService();
    final locService = LocationService();

    var lat = _defaultLat;
    var long = _defaultLong;

    try {
      final isAuto = await prefs.isAutoLocation();
      if (isAuto) {
        final position = await locService.determinePosition();
        lat = position.latitude;
        long = position.longitude;
      } else {
        final stored = await prefs.getStoredLocation();
        if (stored != null) {
          lat = stored['lat'] as double;
          long = stored['long'] as double;
        }
      }
    } catch (e) {
      print('Location Error in getNextPrayer: $e');
    }

    final methodString = await prefs.getCalculationMethod();
    final params = _getCalculationParams(methodString);

    final myCoordinates = Coordinates(lat, long);
    final date = DateComponents.from(DateTime.now());

    // Use same utcOffset as getPrayerTimes for consistency
    final utcOffset = DateTime.now().timeZoneOffset;
    final prayerTimes = PrayerTimes(myCoordinates, date, params, utcOffset: utcOffset);

    return prayerTimes.nextPrayer();
  }

  /// Automatically pick the correct calculation method for a given country.
  String _getMethodForCountry(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'TR': // Turkey
        return 'turkey';
      case 'EG': // Egypt
        return 'egyptian';
      case 'SA': // Saudi Arabia
        return 'umm_al_qura';
      case 'MA': // Morocco
        return 'morocco';
      case 'ID': // Indonesia
        return 'indonesia';
      case 'IN': // India
        return 'north_america'; // ISNA is widely used in India too
      case 'US': // USA
      case 'CA': // Canada
        return 'north_america';
      case 'PK': // Pakistan
        return 'karachi';
      case 'MY': // Malaysia
      case 'SG': // Singapore
        return 'singapore';
      case 'AE': // UAE
        return 'dubai';
      case 'QA': // Qatar
        return 'qatar';
      case 'KW': // Kuwait
        return 'kuwait';
      default:
        return 'muslim_world_league';
    }
  }

  /// Map method string to CalculationParameters
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
      case 'morocco':
        // Morocco: Fajr angle 19°, Isha angle 17° (Moroccan Ministry)
        params = CalculationParameters(fajrAngle: 19.0, ishaAngle: 17.0);
        break;
      case 'indonesia':
        // Indonesia KEMENAG: Fajr angle 20°, Isha angle 18°
        params = CalculationParameters(fajrAngle: 20.0, ishaAngle: 18.0);
        params.madhab = Madhab.shafi;
        break;
      case 'turkey':
      default:
        params = CalculationMethod.turkey.getParameters();
    }

    return params;
  }
}
