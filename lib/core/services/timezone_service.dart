import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for handling timezone operations
/// Provides timezone lookup from coordinates and conversion utilities
class TimezoneService {

  /// Get singleton instance
  factory TimezoneService() {
    _instance ??= TimezoneService._();
    return _instance!;
  }

  TimezoneService._();
  static TimezoneService? _instance;
  bool _initialized = false;

  /// Initialize timezone database
  /// Call this once during app startup
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      tz.initializeTimeZones();
      _initialized = true;
      print('TimezoneService: Initialized successfully');
    } catch (e) {
      print('TimezoneService: Error initializing: $e');
      rethrow;
    }
  }

  /// Get timezone name from coordinates
  /// This is a simplified lookup based on common locations
  /// For production, consider using a more comprehensive timezone lookup service
  String getTimezoneFromCoordinates(double latitude, double longitude) {
    if (!_initialized) {
      throw StateError('TimezoneService not initialized. Call initialize() first.');
    }

    // Simplified timezone lookup based on longitude ranges
    // This covers most major timezones
    // For more accuracy, use a timezone boundary database
    
    // Turkey
    if (latitude >= 36 && latitude <= 42 && longitude >= 26 && longitude <= 45) {
      return 'Europe/Istanbul';
    }
    
    // Egypt
    if (latitude >= 22 && latitude <= 32 && longitude >= 25 && longitude <= 35) {
      return 'Africa/Cairo';
    }
    
    // Saudi Arabia
    if (latitude >= 16 && latitude <= 32 && longitude >= 34 && longitude <= 56) {
      return 'Asia/Riyadh';
    }
    
    // Indonesia (Jakarta)
    if (latitude >= -7 && latitude <= -5 && longitude >= 106 && longitude <= 108) {
      return 'Asia/Jakarta';
    }
    
    // USA East Coast
    if (latitude >= 25 && latitude <= 48 && longitude >= -85 && longitude <= -66) {
      return 'America/New_York';
    }
    
    // USA West Coast
    if (latitude >= 32 && latitude <= 49 && longitude >= -125 && longitude <= -114) {
      return 'America/Los_Angeles';
    }
    
    // UK
    if (latitude >= 50 && latitude <= 60 && longitude >= -8 && longitude <= 2) {
      return 'Europe/London';
    }
    
    // UAE
    if (latitude >= 22 && latitude <= 26 && longitude >= 51 && longitude <= 57) {
      return 'Asia/Dubai';
    }
    
    // Pakistan
    if (latitude >= 24 && latitude <= 37 && longitude >= 60 && longitude <= 78) {
      return 'Asia/Karachi';
    }
    
    // Malaysia
    if (latitude >= 1 && latitude <= 7 && longitude >= 99 && longitude <= 120) {
      return 'Asia/Kuala_Lumpur';
    }
    
    // General fallback based on longitude
    // This provides reasonable estimates for other locations
    if (longitude >= -180 && longitude < -165) return 'Pacific/Midway';
    if (longitude >= -165 && longitude < -150) return 'Pacific/Honolulu';
    if (longitude >= -150 && longitude < -135) return 'America/Anchorage';
    if (longitude >= -135 && longitude < -120) return 'America/Los_Angeles';
    if (longitude >= -120 && longitude < -105) return 'America/Denver';
    if (longitude >= -105 && longitude < -90) return 'America/Chicago';
    if (longitude >= -90 && longitude < -75) return 'America/New_York';
    if (longitude >= -75 && longitude < -60) return 'America/Caracas';
    if (longitude >= -60 && longitude < -45) return 'America/Sao_Paulo';
    if (longitude >= -45 && longitude < -30) return 'Atlantic/South_Georgia';
    if (longitude >= -30 && longitude < -15) return 'Atlantic/Azores';
    if (longitude >= -15 && longitude < 0) return 'Europe/London';
    if (longitude >= 0 && longitude < 15) return 'Europe/Paris';
    if (longitude >= 15 && longitude < 30) return 'Europe/Istanbul';
    if (longitude >= 30 && longitude < 45) return 'Europe/Moscow';
    if (longitude >= 45 && longitude < 60) return 'Asia/Dubai';
    if (longitude >= 60 && longitude < 75) return 'Asia/Karachi';
    if (longitude >= 75 && longitude < 90) return 'Asia/Kolkata';
    if (longitude >= 90 && longitude < 105) return 'Asia/Bangkok';
    if (longitude >= 105 && longitude < 120) return 'Asia/Hong_Kong';
    if (longitude >= 120 && longitude < 135) return 'Asia/Tokyo';
    if (longitude >= 135 && longitude < 150) return 'Australia/Sydney';
    if (longitude >= 150 && longitude < 165) return 'Pacific/Guadalcanal';
    if (longitude >= 165 && longitude <= 180) return 'Pacific/Auckland';
    
    // Default fallback
    return 'UTC';
  }

  /// Convert UTC DateTime to location timezone
  DateTime convertToLocationTime(DateTime utcDateTime, String timezoneName) {
    if (!_initialized) {
      throw StateError('TimezoneService not initialized. Call initialize() first.');
    }

    try {
      final location = tz.getLocation(timezoneName);
      final tzDateTime = tz.TZDateTime.from(utcDateTime, location);
      
      // Return as regular DateTime but in the location's timezone
      return tzDateTime;
    } catch (e) {
      print('TimezoneService: Error converting time for timezone $timezoneName: $e');
      // Fallback: return original UTC time
      return utcDateTime;
    }
  }

  /// Get current time in a specific timezone
  DateTime getCurrentTimeInTimezone(String timezoneName) {
    if (!_initialized) {
      throw StateError('TimezoneService not initialized. Call initialize() first.');
    }

    final location = tz.getLocation(timezoneName);
    return tz.TZDateTime.now(location);
  }

  /// Get timezone location object for advanced operations
  tz.Location? getLocation(String timezoneName) {
    if (!_initialized) return null;
    
    try {
      return tz.getLocation(timezoneName);
    } catch (e) {
      print('TimezoneService: Timezone $timezoneName not found');
      return null;
    }
  }
}
