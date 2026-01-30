import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
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
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getCityFromCoordinates(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        
        // Try to get most specific location name
        String? cityName = place.locality ?? 
                          place.subAdministrativeArea ?? 
                          place.administrativeArea ?? 
                          place.country;
        
        String? countryName = place.country;
        
        if (cityName != null) {
          // Add country if available and different from city
          if (countryName != null && countryName != cityName) {
            return "$cityName, $countryName";
          }
          return cityName;
        }
        
        return "Unknown Location";
      }
      return "Unknown Location";
    } catch (e) {
      print("Geocoding Error: $e");
      return "Unknown Location";
    }
  }
}
