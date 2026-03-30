import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:dio/dio.dart';

part 'update_service.g.dart';

@riverpod
UpdateService updateService(UpdateServiceRef ref) {
  final analytics = ref.read(analyticsServiceProvider);
  return UpdateService(analytics: analytics);
}

class UpdateService {
  UpdateService({required this.analytics});
  final AnalyticsService analytics;
  final NotificationService _notif = NotificationService();

  static const _maxRetries = 3;
  static const _retryDelay = Duration(seconds: 5);

  /// Original foreground download (used by dialog progress)
  Future<void> downloadAndInstall({
    required String apkUrl,
    required BuildContext context,
    required Function(double) onProgress,
    required Function(String) onError,
  }) async {
    final permissionStatus = await Permission.requestInstallPackages.status;
    if (!permissionStatus.isGranted) {
      final result = await Permission.requestInstallPackages.request();
      if (!result.isGranted) {
        onError('يرجى السماح بتثبيت التطبيقات من المصادر الخارجية');
        return;
      }
    }

    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      onError('تعذر الوصول إلى مساحة التخزين');
      return;
    }

    final savePath = '${dir.path}/sila_update.apk';
    final file = File(savePath);
    if (await file.exists()) await file.delete();

    await analytics.logUpdateDownloadStart();

    try {
      final dio = Dio();
      await dio.download(
        apkUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) onProgress(received / total);
        },
      );
      await analytics.logUpdateDownloadComplete();
      final result = await OpenFile.open(savePath);
      if (result.type != ResultType.done) {
        onError('فشل فتح ملف التثبيت: ${result.message}');
      }
    } on DioException catch (e) {
      await analytics.logUpdateDownloadFailed(error: e.message ?? 'unknown');
      onError('فشل التحميل، تحقق من الاتصال بالإنترنت');
    } catch (e) {
      await analytics.logUpdateDownloadFailed(error: e.toString());
      onError('حدث خطأ غير متوقع أثناء التحميل');
    }
  }

  /// Background download — runs with notification, user can use app freely
  Future<void> downloadInBackground({required String apkUrl}) async {
    final locale = _currentLocale;

    // Request permission
    final permissionStatus = await Permission.requestInstallPackages.status;
    if (!permissionStatus.isGranted) {
      final result = await Permission.requestInstallPackages.request();
      if (!result.isGranted) {
        _notif.showDownloadError(
          id: NotificationService.downloadNotificationId,
          locale: locale,
          errorType: 'permission',
          withRetry: false,
        );
        return;
      }
    }

    // Get save path
    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      _notif.showDownloadError(
        id: NotificationService.downloadNotificationId,
        locale: locale,
        errorType: 'storage',
        withRetry: false,
      );
      return;
    }

    final savePath = '${dir.path}/sila_update.apk';

    // Show initial progress notification
    await _notif.showDownloadProgress(
      id: NotificationService.downloadNotificationId,
      locale: locale,
      percent: 0,
    );

    await analytics.logUpdateDownloadStart();

    int retries = 0;
    while (retries < _maxRetries) {
      try {
        await _downloadWithResume(apkUrl, savePath, locale);
        // Success — show install notification
        await _notif.showDownloadComplete(
          id: NotificationService.downloadNotificationId,
          locale: locale,
          apkPath: savePath,
        );
        await analytics.logUpdateDownloadComplete();
        return;
      } on DioException catch (e) {
        retries++;
        debugPrint('Download attempt $retries failed: ${e.message}');

        if (e.type == DioExceptionType.cancel) {
          return; // User cancelled
        }

        // Check if it's a storage issue
        if (e.message?.contains('storage') == true ||
            e.message?.contains('space') == true ||
            e.message?.contains('No space') == true) {
          _notif.showDownloadError(
            id: NotificationService.downloadNotificationId,
            locale: locale,
            errorType: 'storage',
            withRetry: false,
          );
          return;
        }

        // Check if it's a URL issue (403/404)
        if (e.response?.statusCode == 403 || e.response?.statusCode == 404) {
          _notif.showDownloadError(
            id: NotificationService.downloadNotificationId,
            locale: locale,
            errorType: 'url',
            downloadUrl: apkUrl,
            withRetry: false,
          );
          return;
        }

        // Network error — show waiting and retry
        if (retries < _maxRetries) {
          await _notif.showDownloadWaiting(
            id: NotificationService.downloadNotificationId,
            locale: locale,
          );
          await Future.delayed(_retryDelay);
          continue;
        }
      } catch (e) {
        retries++;
        debugPrint('Download attempt $retries failed: $e');
        if (retries < _maxRetries) {
          await _notif.showDownloadWaiting(
            id: NotificationService.downloadNotificationId,
            locale: locale,
          );
          await Future.delayed(_retryDelay);
          continue;
        }
      }
    }

    // All retries exhausted
    await _notif.showDownloadError(
      id: NotificationService.downloadNotificationId,
      locale: locale,
      errorType: 'network',
      downloadUrl: apkUrl,
      withRetry: true,
    );
    await analytics.logUpdateDownloadFailed(error: 'Max retries exceeded');
  }

  /// Download with resume support (Range header for partial files)
  Future<void> _downloadWithResume(
    String apkUrl,
    String savePath,
    String locale,
  ) async {
    int existingBytes = 0;
    final existingFile = File(savePath);
    if (await existingFile.exists()) {
      existingBytes = await existingFile.length();
    }

    final dio = Dio();
    await dio.download(
      apkUrl,
      savePath,
      options: Options(
        headers: existingBytes > 0 ? {'Range': 'bytes=$existingBytes-'} : null,
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(seconds: 30),
      ),
      onReceiveProgress: (received, total) {
        int percent;
        if (total > 0) {
          percent = ((existingBytes + received) / (existingBytes + total) * 100)
              .toInt();
        } else {
          percent = existingBytes > 0 ? 50 : 0; // Unknown total
        }
        percent =
            percent.clamp(0, 99); // Don't show 100% until install notification
        _notif.showDownloadProgress(
          id: NotificationService.downloadNotificationId,
          locale: locale,
          percent: percent,
        );
      },
    );
  }

  String get _currentLocale {
    // Try to get locale from navigator context, fallback to 'ar'
    try {
      // This is a static fallback — the locale is usually available at app level
      return 'ar';
    } catch (_) {
      return 'ar';
    }
  }
}
