import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String keyIsAutoLocation = "is_auto_location";
  static const String keyLat = "latitude";
  static const String keyLong = "longitude";
  static const String keyCity = "city_name";
  static const String keyCalculationMethod = "calculation_method";

  Future<void> setAutoLocation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsAutoLocation, value);
  }

  Future<bool> isAutoLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsAutoLocation) ?? true; // Default to Auto
  }

  Future<void> saveManualLocation(double lat, double long, String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyLat, lat);
    await prefs.setDouble(keyLong, long);
    await prefs.setString(keyCity, cityName);
    await prefs.setBool(keyIsAutoLocation, false); // Switch to manual
  }

  Future<Map<String, dynamic>?> getStoredLocation() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(keyLat)) return null;
    
    return {
      "lat": prefs.getDouble(keyLat),
      "long": prefs.getDouble(keyLong),
      "city": prefs.getString(keyCity) ?? "Manual Location"
    };
  }

  /// Get prayer time calculation method
  /// Returns: 'turkey', 'muslim_world_league', 'egyptian', 'karachi', 'umm_al_qura', 'dubai', 'qatar', 'kuwait', 'singapore', 'north_america', 'france', 'tehran'
  Future<String> getCalculationMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyCalculationMethod) ?? 'turkey'; // Default to Turkey
  }

  /// Set prayer time calculation method
  Future<void> setCalculationMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyCalculationMethod, method);
  }

  // ========== Adhan Settings ==========

  static const String keyAdhanNotificationsEnabled = "adhan_notifications_enabled";
  static const String keyAdhanSound = "adhan_sound";

  /// Check if Adhan notifications are enabled globally
  Future<bool> isAdhanNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAdhanNotificationsEnabled) ?? true; // Default enabled
  }

  /// Enable/disable Adhan notifications globally
  Future<void> setAdhanNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAdhanNotificationsEnabled, enabled);
  }

  /// Check if Adhan is enabled for specific prayer
  Future<bool> isAdhanEnabled(String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'adhan_enabled_${prayerName.toLowerCase()}';
    return prefs.getBool(key) ?? true; // Default enabled
  }

  /// Enable/disable Adhan for specific prayer
  Future<void> setAdhanEnabled(String prayerName, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'adhan_enabled_${prayerName.toLowerCase()}';
    await prefs.setBool(key, enabled);
  }

  /// Get selected Adhan sound
  /// Returns: 'adhan_mecca.mp3', 'adhan_medina.mp3', 'adhan_egypt.mp3', 'adhan_mishary.mp3', 'adhan_turkey.mp3'
  Future<String> getAdhanSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAdhanSound) ?? 'adhan_mecca.mp3'; // Default
  }

  /// Set Adhan sound
  Future<void> setAdhanSound(String soundFile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAdhanSound, soundFile);
  }
}
