import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String keyIsAutoLocation = "is_auto_location";
  static const String keyLat = "latitude";
  static const String keyLong = "longitude";
  static const String keyCity = "city_name";

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
}
