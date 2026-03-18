import 'package:equatable/equatable.dart';

enum OnErrorBehavior {
  speakAndContinue,
  waitForUser,
  continueOnly,
}

enum AttemptsMode {
  one,
  two,
  three,
}

enum StrictnessLevel {
  easy,
  medium,
  strict,
}

class TasmiPreferences extends Equatable {
  final OnErrorBehavior onErrorBehavior;
  final AttemptsMode attemptsMode;
  final bool ttsEnabled;
  final StrictnessLevel strictness;
  final bool isOnboardingDone;

  const TasmiPreferences({
    required this.onErrorBehavior,
    required this.attemptsMode,
    required this.ttsEnabled,
    required this.strictness,
    required this.isOnboardingDone,
  });

  factory TasmiPreferences.defaults() => const TasmiPreferences(
        onErrorBehavior: OnErrorBehavior.speakAndContinue,
        attemptsMode: AttemptsMode.two,
        ttsEnabled: true,
        strictness: StrictnessLevel.medium,
        isOnboardingDone: false,
      );

  TasmiPreferences copyWith({
    OnErrorBehavior? onErrorBehavior,
    AttemptsMode? attemptsMode,
    bool? ttsEnabled,
    StrictnessLevel? strictness,
    bool? isOnboardingDone,
  }) {
    return TasmiPreferences(
      onErrorBehavior: onErrorBehavior ?? this.onErrorBehavior,
      attemptsMode: attemptsMode ?? this.attemptsMode,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      strictness: strictness ?? this.strictness,
      isOnboardingDone: isOnboardingDone ?? this.isOnboardingDone,
    );
  }

  @override
  List<Object?> get props => [
        onErrorBehavior,
        attemptsMode,
        ttsEnabled,
        strictness,
        isOnboardingDone,
      ];
}
