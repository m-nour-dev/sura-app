import 'package:isar/isar.dart';

part 'hifz_settings.g.dart';

enum HifzVerificationMode { easy, normal, strict }

@collection
class HifzSettings {
  Id id = Isar.autoIncrement;

  late int verificationModeIndex;
  late int attemptsBeforeHint;
  late int hintDelaySeconds;
  late int listenRepeats;
  late int ayahsPerSession;
  late bool hideVisibleDiacritics;
  late bool playCorrectOnError;
  late bool beginnerMode;
  late bool smartStrictness;
  late bool nightMode;

  HifzVerificationMode readVerificationMode() {
    if (verificationModeIndex < 0 ||
        verificationModeIndex >= HifzVerificationMode.values.length) {
      return HifzVerificationMode.normal;
    }
    return HifzVerificationMode.values[verificationModeIndex];
  }

  void setVerificationMode(HifzVerificationMode mode) {
    verificationModeIndex = mode.index;
  }

  static HifzSettings defaults() {
    return HifzSettings()
      ..id = 1
      ..verificationModeIndex = HifzVerificationMode.normal.index
      ..attemptsBeforeHint = 2
      ..hintDelaySeconds = 2
      ..listenRepeats = 1
      ..ayahsPerSession = 5
      ..hideVisibleDiacritics = false
      ..playCorrectOnError = false
      ..beginnerMode = false
      ..smartStrictness = false
      ..nightMode = true;
  }
}
