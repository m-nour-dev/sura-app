import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/features/hifz/data/models/hifz_user_profile.dart';
import 'package:sila_app/features/hifz/data/repositories/hifz_repository_provider.dart';
import 'package:sila_app/features/hifz/domain/plan_generator.dart';

part 'hifz_onboarding_controller.g.dart';

class HifzOnboardingState {
  final int currentPage;
  final int? ageGroup;
  final int? dailyMinutes;
  final int? goal;
  final int? learningStyle;
  final bool autoAdapt;
  final bool isSaving;
  final bool onboardingDone;
  final String? errorMessage;
  final HifzDailyPlan? previewPlan;

  const HifzOnboardingState({
    required this.currentPage,
    required this.ageGroup,
    required this.dailyMinutes,
    required this.goal,
    required this.learningStyle,
    required this.autoAdapt,
    required this.isSaving,
    required this.onboardingDone,
    required this.errorMessage,
    required this.previewPlan,
  });

  factory HifzOnboardingState.initial() {
    return const HifzOnboardingState(
      currentPage: 0,
      ageGroup: null,
      dailyMinutes: null,
      goal: null,
      learningStyle: null,
      autoAdapt: true,
      isSaving: false,
      onboardingDone: false,
      errorMessage: null,
      previewPlan: null,
    );
  }

  HifzOnboardingState copyWith({
    int? currentPage,
    int? ageGroup,
    bool clearAgeGroup = false,
    int? dailyMinutes,
    bool clearDailyMinutes = false,
    int? goal,
    bool clearGoal = false,
    int? learningStyle,
    bool clearLearningStyle = false,
    bool? autoAdapt,
    bool? isSaving,
    bool? onboardingDone,
    String? errorMessage,
    bool clearErrorMessage = false,
    HifzDailyPlan? previewPlan,
  }) {
    return HifzOnboardingState(
      currentPage: currentPage ?? this.currentPage,
      ageGroup: clearAgeGroup ? null : ageGroup ?? this.ageGroup,
      dailyMinutes: clearDailyMinutes ? null : dailyMinutes ?? this.dailyMinutes,
      goal: clearGoal ? null : goal ?? this.goal,
      learningStyle: clearLearningStyle ? null : learningStyle ?? this.learningStyle,
      autoAdapt: autoAdapt ?? this.autoAdapt,
      isSaving: isSaving ?? this.isSaving,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      previewPlan: previewPlan ?? this.previewPlan,
    );
  }
}

@riverpod
class HifzOnboardingController extends _$HifzOnboardingController {
  static const _onboardingDoneKey = 'hifz_onboarding_done';

  @override
  HifzOnboardingState build() {
    unawaited(_loadOnboardingFlag());
    return HifzOnboardingState.initial();
  }

  Future<void> _loadOnboardingFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool(_onboardingDoneKey) ?? false;
    if (!done) {
      return;
    }
    state = state.copyWith(onboardingDone: true);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page, clearErrorMessage: true);
  }

  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1, clearErrorMessage: true);
  }

  void setAgeGroup(int value) {
    state = state.copyWith(ageGroup: value, clearErrorMessage: true);
  }

  void setDailyMinutes(int value) {
    state = state.copyWith(dailyMinutes: value, clearErrorMessage: true);
    _refreshPreviewPlan();
  }

  void setGoal(int value) {
    state = state.copyWith(goal: value, clearErrorMessage: true);
    _refreshPreviewPlan();
  }

  void setLearningStyle(int value) {
    state = state.copyWith(learningStyle: value, clearErrorMessage: true);
  }

  void setAutoAdapt(bool value) {
    state = state.copyWith(autoAdapt: value);
  }

  Future<void> finishOnboarding() async {
    if (state.ageGroup == null ||
        state.dailyMinutes == null ||
        state.goal == null ||
        state.learningStyle == null) {
      state = state.copyWith(errorMessage: 'يرجى إكمال جميع الإجابات');
      return;
    }

    state = state.copyWith(isSaving: true, clearErrorMessage: true);

    try {
      final repository = await ref.read(hifzRepositoryProvider.future);

      final profile = HifzUserProfile()
        ..ageGroup = state.ageGroup!
        ..dailyMinutes = state.dailyMinutes!
        ..goal = state.goal!
        ..learningStyle = state.learningStyle!
        ..autoAdapt = state.autoAdapt
        ..createdAt = DateTime.now();

      await repository.saveProfile(profile);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingDoneKey, true);

      state = state.copyWith(isSaving: false, onboardingDone: true);
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'حدث خطأ أثناء حفظ الخطة، حاول مرة أخرى',
      );
    }
  }

  Future<void> completeOnboarding() async {
    await finishOnboarding();
  }

  void _refreshPreviewPlan() {
    if (state.dailyMinutes == null || state.goal == null) {
      return;
    }

    final profile = HifzUserProfile()
      ..ageGroup = state.ageGroup ?? 1
      ..dailyMinutes = state.dailyMinutes!
      ..goal = state.goal!
      ..learningStyle = state.learningStyle ?? 2
      ..autoAdapt = state.autoAdapt
      ..createdAt = DateTime.now();

    state = state.copyWith(previewPlan: PlanGenerator.generate(profile));
  }
}
