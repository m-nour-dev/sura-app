import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@riverpod
AnalyticsService analyticsService(AnalyticsServiceRef ref) =>
    AnalyticsService();

/// No-op analytics service (Firebase removed).
/// All methods simply log to debug console.
class AnalyticsService {
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    debugPrint('📊 [Analytics] $name ${parameters ?? ''}');
  }

  Future<void> logScreenHome() async =>
      debugPrint('📊 [Analytics] screen_home');
  Future<void> logScreenQuran() async =>
      debugPrint('📊 [Analytics] screen_quran');
  Future<void> logScreenHifz() async =>
      debugPrint('📊 [Analytics] screen_hifz');
  Future<void> logScreenPrayers() async =>
      debugPrint('📊 [Analytics] screen_prayers');
  Future<void> logScreenAzkar() async =>
      debugPrint('📊 [Analytics] screen_azkar');

  Future<void> logQuranSurahOpen({
    required String surahName,
    required int surahNumber,
  }) async {
    debugPrint('📊 [Analytics] quran_surah_open: $surahName #$surahNumber');
  }

  Future<void> logPlayAudio({
    required String surahName,
    required int ayahNumber,
  }) async {
    debugPrint('📊 [Analytics] play_audio: $surahName ayah $ayahNumber');
  }

  Future<void> logHifzSessionStart({
    required String surahName,
    required String method,
  }) async {
    debugPrint('📊 [Analytics] hifz_session_start: $surahName ($method)');
  }

  Future<void> logHifzSessionComplete({
    required int ayahsCount,
    required double accuracy,
    required int hasanat,
  }) async {
    debugPrint('📊 [Analytics] hifz_session_complete: $ayahsCount ayahs, ${accuracy}% accuracy');
  }

  Future<void> logHifzOnboardingComplete() async {
    debugPrint('📊 [Analytics] hifz_onboarding_complete');
  }

  Future<void> logTasmiSessionStart({required String surahName}) async {
    debugPrint('📊 [Analytics] tasmi_session_start: $surahName');
  }

  Future<void> logTasmiSessionComplete({
    required double accuracy,
    required int errorsCount,
  }) async {
    debugPrint('📊 [Analytics] tasmi_session_complete: ${accuracy}% accuracy, $errorsCount errors');
  }

  Future<void> logAzkarCategoryOpen({required String categoryName}) async {
    debugPrint('📊 [Analytics] azkar_category_open: $categoryName');
  }

  Future<void> logAzkarComplete({required String categoryName}) async {
    debugPrint('📊 [Analytics] azkar_complete: $categoryName');
  }

  Future<void> logWirdPageRead({required int pageNumber}) async {
    debugPrint('📊 [Analytics] wird_page_read: page $pageNumber');
  }

  Future<void> logWirdKhatmaComplete() async {
    debugPrint('📊 [Analytics] wird_khatma_complete');
  }

  Future<void> logQiblahOpen() async =>
      debugPrint('📊 [Analytics] qiblah_open');

  Future<void> logVefaPersonAdd() async =>
      debugPrint('📊 [Analytics] vefa_person_add');

  Future<void> logVefaDuaSend({required int personCount}) async {
    debugPrint('📊 [Analytics] vefa_dua_send: $personCount persons');
  }

  Future<void> logUpdateDialogShown({required int newVersion}) async {
    debugPrint('📊 [Analytics] update_dialog_shown: v$newVersion');
  }

  Future<void> logUpdateAccepted() async =>
      debugPrint('📊 [Analytics] update_accepted');
  Future<void> logUpdateDismissed() async =>
      debugPrint('📊 [Analytics] update_dismissed');
  Future<void> logUpdateDownloadStart() async =>
      debugPrint('📊 [Analytics] update_download_start');
  Future<void> logUpdateDownloadComplete() async =>
      debugPrint('📊 [Analytics] update_download_complete');

  Future<void> logUpdateDownloadFailed({required String error}) async {
    debugPrint('📊 [Analytics] update_download_failed: $error');
  }

  Future<void> setUserProperties({required String appVersion}) async {
    debugPrint('📊 [Analytics] setUserProperties: appVersion=$appVersion');
  }
}
