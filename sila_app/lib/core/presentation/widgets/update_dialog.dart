import 'package:flutter/material.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/core/services/remote_config_service.dart';
import 'package:sila_app/core/services/update_service.dart';

class UpdateDialog extends StatefulWidget {
  final UpdateCheckResult updateResult;
  final UpdateService updateService;
  final AnalyticsService analyticsService;

  const UpdateDialog({
    super.key,
    required this.updateResult,
    required this.updateService,
    required this.analyticsService,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double _progress = 0;
  bool _isDownloading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.updateResult.isForced && !_isDownloading,
      child: AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.system_update_rounded,
                color: Color(0xFF064E3B),
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.updateResult.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064E3B),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.updateResult.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (widget.updateResult.releaseNotes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.updateResult.releaseNotes,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            if (_isDownloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF064E3B),
                borderRadius: BorderRadius.circular(4),
                minHeight: 8,
              ),
              const SizedBox(height: 6),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Color(0xFF064E3B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: _isDownloading
            ? []
            : [
                if (!widget.updateResult.isForced)
                  TextButton(
                    onPressed: () async {
                      await widget.analyticsService.logUpdateDismissed();
                      if (mounted) Navigator.of(context).pop();
                    },
                    child: Text(
                      'تجاهل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _startDownload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'تحديث الآن',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
      ),
    );
  }

  Future<void> _startDownload() async {
    await widget.analyticsService.logUpdateAccepted();

    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });

    await widget.updateService.downloadAndInstall(
      apkUrl: widget.updateResult.apkUrl,
      context: context,
      onProgress: (progress) {
        if (mounted) {
          setState(() => _progress = progress);
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _errorMessage = error;
          });
        }
      },
    );
  }
}
