import 'package:equatable/equatable.dart';

class Ibtihal extends Equatable {
  final String id;
  final String title;
  final String url;
  final String artistName;
  final String? duration;

  const Ibtihal({
    required this.id,
    required this.title,
    required this.url,
    required this.artistName,
    this.duration,
  });

  @override
  List<Object?> get props => [id, title, url, artistName, duration];
}
