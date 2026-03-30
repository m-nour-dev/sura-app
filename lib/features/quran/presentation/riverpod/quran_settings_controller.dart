import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';

part 'quran_settings_controller.g.dart';

@riverpod
class QuranSettingsController extends _$QuranSettingsController {
  static const _fontSizeKey = 'quran_font_size';
  static const _fontFamilyKey = 'quran_font_family';
  static const _themeModeKey = 'quran_theme_mode';

  @override
  FutureOr<QuranSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    
    return QuranSettings(
      fontSize: prefs.getDouble(_fontSizeKey) ?? 26,
      fontFamily: prefs.getString(_fontFamilyKey) ?? 'Scheherazade New',
      themeMode: QuranThemeMode.values[prefs.getInt(_themeModeKey) ?? 2], // Default to Sepia
    );
  }

  Future<void> updateFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
    state = AsyncData(state.value!.copyWith(fontSize: size));
  }

  Future<void> updateFontFamily(String family) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, family);
    state = AsyncData(state.value!.copyWith(fontFamily: family));
  }

  Future<void> updateThemeMode(QuranThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    state = AsyncData(state.value!.copyWith(themeMode: mode));
  }
}
