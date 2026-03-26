import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/core/services/analytics_service.dart';

part 'update_service.g.dart';

@riverpod
UpdateService updateService(UpdateServiceRef ref) {
  final analytics = ref.read(analyticsServiceProvider);
  return UpdateService(analytics: analytics);
}

class UpdateService {

  UpdateService({required this.analytics});
  final AnalyticsService analytics;

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
    if (await file.exists()) {
      await file.delete();
    }

    await analytics.logUpdateDownloadStart();

    try {
      final dio = Dio();
      await dio.download(
        apkUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            onProgress(received / total);
          }
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
}
