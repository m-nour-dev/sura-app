import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int number;
  final String text;
  final String translation; // Localized translation
  final String? audioUrl; // Remote Audio URL

  const Ayah({
    required this.number,
    required this.text,
    required this.translation,
    this.audioUrl,
  });

  @override
  List<Object?> get props => [number, text, translation, audioUrl];
}
