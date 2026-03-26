import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackSheet(),
    );
  }

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  final _problemController = TextEditingController();
  final _suggestionController = TextEditingController();
  final _nextUpdateController = TextEditingController();
  final _favoriteController = TextEditingController();

  int _rating = 0;
  String? _usageFrequency;
  bool _isSending = false;
  bool _sent = false;

  // ─── Colors ────────────────────────────────────────────────────────
  static const _emerald = Color(0xFF064E3B);
  static const _gold = Color(0xFFD97706);
  static const _goldLight = Color(0xFFFCD34D);
  static const _parchment = Color(0xFFFDFBF7);
  static const _navy = Color(0xFF1E3A5F);
  static const _txtPrimary = Color(0xFF0F172A);
  static const _txtSecondary = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _divider = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _problemController.dispose();
    _suggestionController.dispose();
    _nextUpdateController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // FIX: Prevent empty feedback writes
    final hasRating = _rating > 0;
    final hasText = _problemController.text.trim().isNotEmpty ||
        _suggestionController.text.trim().isNotEmpty ||
        _nextUpdateController.text.trim().isNotEmpty ||
        _favoriteController.text.trim().isNotEmpty;
    final hasUsage = _usageFrequency != null;
    if (!hasRating && !hasText && !hasUsage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'feedback_placeholder_suggestion'.tr()), // "Write something..."
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final localeCode = context.locale.languageCode;
      final data = {
        'rating': _rating > 0 ? _rating : null,
        'problem': _problemController.text.trim(),
        'suggestion': _suggestionController.text.trim(),
        'nextUpdate': _nextUpdateController.text.trim(),
        'usageFrequency': _usageFrequency,
        'favoriteFeature': _favoriteController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'appVersion': '${packageInfo.version}+${packageInfo.buildNumber}',
        'locale': localeCode,
        'platform': Platform.operatingSystem,
      };

      await FirebaseFirestore.instance
          .collection('feedback')
          .add(data)
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        setState(() {
          _isSending = false;
          _sent = true;
        });
        await Future<void>.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('feedback_error'.tr()),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _parchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: _sent ? _buildSuccess() : _buildForm(context),
    );
  }

  Widget _buildSuccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _emerald.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: _emerald, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            'feedback_success'.tr(),
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _emerald,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Fixed header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'feedback_title'.tr(),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _emerald,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'feedback_subtitle'.tr(),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: _txtSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: _divider),
            ],
          ),
        ),

        // ── Scrollable content ──
        Flexible(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              bottomInset > 0 ? 16 : safeBottom + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Rating ──
                Text(
                  'feedback_rating'.tr(),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _txtPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < _rating;
                    return GestureDetector(
                      onTap: () => setState(() => _rating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          filled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: filled ? _goldLight : _border,
                          size: 36,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                Container(height: 1, color: _divider),
                const SizedBox(height: 16),

                // ── Problem Field ──
                _buildLabel('feedback_problem'.tr()),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _problemController,
                  hint: 'feedback_placeholder_problem'.tr(),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                // ── Suggestion Field ──
                _buildLabel('feedback_suggestion'.tr()),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _suggestionController,
                  hint: 'feedback_placeholder_suggestion'.tr(),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                // ── Next Update Field ──
                _buildLabel('feedback_next_update'.tr()),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nextUpdateController,
                  hint: 'feedback_placeholder_next'.tr(),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                Container(height: 1, color: _divider),
                const SizedBox(height: 16),

                // ── Usage Frequency ──
                _buildLabel('feedback_usage'.tr()),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildUsageChip('daily', 'feedback_usage_daily'.tr()),
                    _buildUsageChip('multiple', 'feedback_usage_multiple'.tr()),
                    _buildUsageChip(
                        'sometimes', 'feedback_usage_sometimes'.tr()),
                    _buildUsageChip('rarely', 'feedback_usage_rarely'.tr()),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Favorite Feature Field ──
                _buildLabel('feedback_favorite'.tr()),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _favoriteController,
                  hint: 'feedback_placeholder_favorite'.tr(),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),

        // ── Fixed buttons at bottom ──
        Container(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            bottomInset > 0 ? 12 : safeBottom + 16,
          ),
          decoration: BoxDecoration(
            color: _parchment,
            boxShadow: bottomInset > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _gold,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: _gold.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'feedback_send'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _txtSecondary,
                    side: const BorderSide(color: _border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'feedback_close'.tr(),
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: _txtPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        color: _txtPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          color: _txtSecondary,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _emerald, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildUsageChip(String value, String label) {
    final selected = _usageFrequency == value;
    return GestureDetector(
      onTap: () => setState(() {
        _usageFrequency = selected ? null : value;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _navy : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _navy : _border,
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : _txtPrimary,
          ),
        ),
      ),
    );
  }
}
