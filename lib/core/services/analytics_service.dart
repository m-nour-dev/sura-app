import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@riverpod
AnalyticsService analyticsService(AnalyticsServiceRef ref) =>
    AnalyticsService();

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logScreenHome() async =>
      _analytics.logEvent(name: 'screen_home');
  Future<void> logScreenQuran() async =>
      _analytics.logEvent(name: 'screen_quran');
  Future<void> logScreenHifz() async =>
      _analytics.logEvent(name: 'screen_hifz');
  Future<void> logScreenPrayers() async =>
      _analytics.logEvent(name: 'screen_prayers');
  Future<void> logScreenAzkar() async =>
      _analytics.logEvent(name: 'screen_azkar');

  Future<void> logQuranSurahOpen({
    required String surahName,
    required int surahNumber,
  }) async {
    await _analytics.logEvent(
      name: 'quran_surah_open',
      parameters: {
        'surah_name': surahName,
        'surah_number': surahNumber,
      },
    );
  }

  Future<void> logPlayAudio({
    required String surahName,
    required int ayahNumber,
  }) async {
    await _analytics.logEvent(
      name: 'play_audio',
      parameters: {
        'surah_name': surahName,
        'ayah_number': ayahNumber,
      },
    );
  }

  Future<void> logHifzSessionStart({
    required String surahName,
    required String method,
  }) async {
    await _analytics.logEvent(
      name: 'hifz_session_start',
      parameters: {
        'surah_name': surahName,
        'method': method,
      },
    );
  }

  Future<void> logHifzSessionComplete({
    required int ayahsCount,
    required double accuracy,
    required int hasanat,
  }) async {
    await _analytics.logEvent(
      name: 'hifz_session_complete',
      parameters: {
        'ayahs_count': ayahsCount,
        'accuracy': accuracy,
        'hasanat': hasanat,
      },
    );
  }

  Future<void> logHifzOnboardingComplete() async {
    await _analytics.logEvent(name: 'hifz_onboarding_complete');
  }

  Future<void> logTasmiSessionStart({required String surahName}) async {
    await _analytics.logEvent(
      name: 'tasmi_session_start',
      parameters: {'surah_name': surahName},
    );
  }

  Future<void> logTasmiSessionComplete({
    required double accuracy,
    required int errorsCount,
  }) async {
    await _analytics.logEvent(
      name: 'tasmi_session_complete',
      parameters: {
        'accuracy': accuracy,
        'errors_count': errorsCount,
      },
    );
  }

  Future<void> logAzkarCategoryOpen({required String categoryName}) async {
    await _analytics.logEvent(
      name: 'azkar_category_open',
      parameters: {'category_name': categoryName},
    );
  }

  Future<void> logAzkarComplete({required String categoryName}) async {
    await _analytics.logEvent(
      name: 'azkar_complete',
      parameters: {'category_name': categoryName},
    );
  }

  Future<void> logWirdPageRead({required int pageNumber}) async {
    await _analytics.logEvent(
      name: 'wird_page_read',
      parameters: {'page_number': pageNumber},
    );
  }

  Future<void> logWirdKhatmaComplete() async {
    await _analytics.logEvent(name: 'wird_khatma_complete');
  }

  Future<void> logQiblahOpen() async =>
      _analytics.logEvent(name: 'qiblah_open');

  Future<void> logVefaPersonAdd() async =>
      _analytics.logEvent(name: 'vefa_person_add');

  Future<void> logVefaDuaSend({required int personCount}) async {
    await _analytics.logEvent(
      name: 'vefa_dua_send',
      parameters: {'person_count': personCount},
    );
  }

  Future<void> logUpdateDialogShown({required int newVersion}) async {
    await _analytics.logEvent(
      name: 'update_dialog_shown',
      parameters: {'new_version': newVersion},
    );
  }

  Future<void> logUpdateAccepted() async =>
      _analytics.logEvent(name: 'update_accepted');
  Future<void> logUpdateDismissed() async =>
      _analytics.logEvent(name: 'update_dismissed');
  Future<void> logUpdateDownloadStart() async =>
      _analytics.logEvent(name: 'update_download_start');
  Future<void> logUpdateDownloadComplete() async =>
      _analytics.logEvent(name: 'update_download_complete');

  Future<void> logUpdateDownloadFailed({required String error}) async {
    await _analytics.logEvent(
      name: 'update_download_failed',
      parameters: {'error': error},
    );
  }

  Future<void> setUserProperties({required String appVersion}) async {
    await _analytics.setUserProperty(name: 'app_version', value: appVersion);
  }
}
