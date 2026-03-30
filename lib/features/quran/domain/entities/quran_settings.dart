import 'package:equatable/equatable.dart';

enum QuranThemeMode { light, dark, sepia }

class QuranSettings extends Equatable {
  const QuranSettings({
    required this.fontSize,
    required this.fontFamily,
    required this.themeMode,
  });
  final double fontSize;
  final String fontFamily;
  final QuranThemeMode themeMode;

  static const defaultSettings = QuranSettings(
    fontSize: 26,
    fontFamily: 'Scheherazade New',
    themeMode: QuranThemeMode.sepia,
  );

  QuranSettings copyWith({
    double? fontSize,
    String? fontFamily,
    QuranThemeMode? themeMode,
  }) {
    return QuranSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [fontSize, fontFamily, themeMode];
}
