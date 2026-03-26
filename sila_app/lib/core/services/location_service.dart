import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Returns a map with 'city', 'country', 'countryCode' keys.
  Future<Map<String, String>> getLocationInfo(double lat, double long) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Try progressively broader area names if specific ones are null/empty
        var city = place.locality;
        if (city == null || city.isEmpty) city = place.subAdministrativeArea;
        if (city == null || city.isEmpty) city = place.administrativeArea;
        if (city == null || city.isEmpty) city = place.name;
        if (city == null || city.isEmpty) city = place.thoroughfare;
        
        city ??= 'موقع غير معروف'; // Fallback Arabic

        final country = place.country ?? '';
        final countryCode = place.isoCountryCode ?? 'XX';

        final displayCity =
            (country.isNotEmpty && country != city) ? '$city, $country' : city;

        return {
          'city': displayCity,
          'country': country,
          'countryCode': countryCode,
        };
      }
      return {'city': 'موقع غير معروف', 'country': '', 'countryCode': 'XX'};
    } catch (e) {
      print('Geocoding Error: $e');
       return {'city': 'موقع غير معروف', 'country': '', 'countryCode': 'XX'};
    }
  }

  /// Legacy helper — kept for backward compat
  Future<String> getCityFromCoordinates(double lat, double long) async {
    final info = await getLocationInfo(lat, long);
    return info['city'] ?? 'Unknown Location';
  }
}
