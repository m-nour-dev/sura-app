import 'package:equatable/equatable.dart';

class Ayah extends Equatable { // Remote Audio URL

  const Ayah({
    required this.number,
    required this.text,
    required this.translation,
    this.audioUrl,
  });
  final int number;
  final String text;
  final String translation; // Localized translation
  final String? audioUrl;

  @override
  List<Object?> get props => [number, text, translation, audioUrl];
}
