import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String _keyIsAutoLocation = 'is_auto_location';
  static const String _keyLat = 'latitude';
  static const String _keyLong = 'longitude';
  static const String _keyCity = 'city_name';
  static const String _keyCountryCode = 'country_code';
  static const String _keyCalculationMethod = 'calculation_method';
  static const String _keyAdhanNotificationsEnabled = 'adhan_notifications_enabled';
  static const String _keyAdhanSound = 'adhan_sound';

  // ─── Location ────────────────────────────────────────────────────────────

  Future<void> setAutoLocation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsAutoLocation, value);
  }

  Future<bool> isAutoLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAutoLocation) ?? true;
  }

  Future<void> saveManualLocation(
    double lat,
    double long,
    String cityName, {
    String countryCode = 'XX',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLat, lat);
    await prefs.setDouble(_keyLong, long);
    await prefs.setString(_keyCity, cityName);
    await prefs.setString(_keyCountryCode, countryCode);
    await prefs.setBool(_keyIsAutoLocation, false);
  }

  Future<Map<String, dynamic>?> getStoredLocation() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyLat)) return null;
    return {
      'lat': prefs.getDouble(_keyLat),
      'long': prefs.getDouble(_keyLong),
      'city': prefs.getString(_keyCity) ?? 'Manual Location',
      'countryCode': prefs.getString(_keyCountryCode) ?? 'XX',
    };
  }

  Future<void> saveCountryCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCountryCode, code);
  }

  Future<String> getCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCountryCode) ?? 'XX';
  }

  // ─── Calculation Method ───────────────────────────────────────────────────

  Future<String> getCalculationMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCalculationMethod) ?? 'turkey';
  }

  Future<void> setCalculationMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCalculationMethod, method);
  }

  // ─── Adhan Settings ───────────────────────────────────────────────────────

  Future<bool> isAdhanNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAdhanNotificationsEnabled) ?? true;
  }

  Future<void> setAdhanNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAdhanNotificationsEnabled, enabled);
  }

  Future<bool> isAdhanEnabled(String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('adhan_enabled_${prayerName.toLowerCase()}') ?? true;
  }

  Future<void> setAdhanEnabled(String prayerName, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_enabled_${prayerName.toLowerCase()}', enabled);
  }

  Future<String> getAdhanSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAdhanSound) ?? 'adhan_mecca.mp3';
  }

  Future<void> setAdhanSound(String soundFile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAdhanSound, soundFile);
  }
}
