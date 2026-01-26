import 'package:equatable/equatable.dart';

class PrayerTimesEntity extends Equatable {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final String locationName;
  final double latitude;
  final double longitude;

  const PrayerTimesEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha, locationName, latitude, longitude];
}
