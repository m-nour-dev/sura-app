import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_preferences.dart';

class TasmiPreferencesRepository {
  static const _keyOnError = 'tasmi_on_error';
  static const _keyAttempts = 'tasmi_attempts';
  static const _keyTts = 'tasmi_tts';
  static const _keyStrictness = 'tasmi_strictness';
  static const _keyDone = 'tasmi_onboarding_done';

  final SharedPreferences _prefs;

  TasmiPreferencesRepository(this._prefs);

  TasmiPreferences load() {
    final done = _prefs.getBool(_keyDone) ?? false;
    if (!done) return TasmiPreferences.defaults();

    return TasmiPreferences(
      onErrorBehavior: OnErrorBehavior.values[_prefs.getInt(_keyOnError) ?? 0],
      attemptsMode: AttemptsMode.values[_prefs.getInt(_keyAttempts) ?? 1],
      ttsEnabled: _prefs.getBool(_keyTts) ?? true,
      strictness: StrictnessLevel.values[_prefs.getInt(_keyStrictness) ?? 1],
      isOnboardingDone: true,
    );
  }

  Future<void> save(TasmiPreferences prefs) async {
    await _prefs.setInt(_keyOnError, prefs.onErrorBehavior.index);
    await _prefs.setInt(_keyAttempts, prefs.attemptsMode.index);
    await _prefs.setBool(_keyTts, prefs.ttsEnabled);
    await _prefs.setInt(_keyStrictness, prefs.strictness.index);
    await _prefs.setBool(_keyDone, prefs.isOnboardingDone);
  }
}
