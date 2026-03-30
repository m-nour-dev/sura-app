import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_service.g.dart';

@riverpod
RemoteConfigService remoteConfigService(RemoteConfigServiceRef ref) =>
    RemoteConfigService();

class RemoteConfigService {
  final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval:
            kDebugMode ? const Duration(minutes: 1) : const Duration(hours: 12),
      ),
    );

    await _config.setDefaults({
      'latest_version': 4,
      'force_update': false,
      'apk_url': '',
      'update_release_notes': '',
    });

    await _config.fetchAndActivate();
    _initialized = true;
  }

  int get latestVersion => _config.getInt('latest_version');
  bool get forceUpdate => _config.getBool('force_update');
  String get apkUrl => _config.getString('apk_url');
  String get updateReleaseNotes => _config.getString('update_release_notes');

  Future<UpdateCheckResult> checkForUpdate(int currentVersion) async {
    try {
      if (!_initialized) {
        await initialize();
      }

      await _config.fetchAndActivate();

      if (latestVersion > currentVersion) {
        return UpdateCheckResult(
          hasUpdate: true,
          isForced: forceUpdate,
          latestVersion: latestVersion,
          apkUrl: apkUrl,
          releaseNotes: updateReleaseNotes,
        );
      }

      return const UpdateCheckResult(hasUpdate: false);
    } catch (_) {
      return const UpdateCheckResult(hasUpdate: false);
    }
  }
}

class UpdateCheckResult {
  const UpdateCheckResult({
    required this.hasUpdate,
    this.isForced = false,
    this.latestVersion = 0,
    this.apkUrl = '',
    this.releaseNotes = '',
  });
  final bool hasUpdate;
  final bool isForced;
  final int latestVersion;
  final String apkUrl;
  final String releaseNotes;
}
