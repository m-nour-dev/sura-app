import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_service.g.dart';

@riverpod
RemoteConfigService remoteConfigService(RemoteConfigServiceRef ref) =>
    RemoteConfigService();

/// Hardcoded config service (Firebase Remote Config removed).
/// Returns static defaults — update checking is effectively disabled.
class RemoteConfigService {
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    debugPrint('📋 [RemoteConfig] Initialized with local defaults (no Firebase)');
  }

  int get latestVersion => 0;
  bool get forceUpdate => false;
  String get apkUrl => '';
  String get updateReleaseNotes => '';

  Future<UpdateCheckResult> checkForUpdate(int currentVersion) async {
    if (!_initialized) {
      await initialize();
    }
    // No remote config — never report updates
    return const UpdateCheckResult(hasUpdate: false);
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
