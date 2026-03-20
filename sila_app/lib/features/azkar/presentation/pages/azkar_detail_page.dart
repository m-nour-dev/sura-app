import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sila_app/core/presentation/widgets/sila_app_bar.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/features/azkar/data/models/azkar_model.dart';
import 'package:sila_app/features/azkar/presentation/riverpod/azkar_controller.dart';
import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';

class AzkarDetailPage extends ConsumerStatefulWidget {
  final String categoryId;
  final String title;

  const AzkarDetailPage({super.key, required this.categoryId, required this.title});

  @override
  ConsumerState<AzkarDetailPage> createState() => _AzkarDetailPageState();
}

class _AzkarDetailPageState extends ConsumerState<AzkarDetailPage> {
  // Map to track progress of each item: index -> currentCount
  final Map<int, int> _counts = {};

  void _checkCompletion(List items) {
    if (items.isEmpty) return;

    // Check if all items are completed
    bool allCompleted = true;
    for (int i = 0; i < items.length; i++) {
      final requiredCount = items[i].count;
      final currentCount = _counts[i] ?? 0;
      if (currentCount < requiredCount) {
        allCompleted = false;
        break;
      }
    }

    if (allCompleted) {
      ref.read(analyticsServiceProvider).logAzkarComplete(
            categoryName: widget.categoryId,
          );
      // Small delay to let the UI update last count
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showVefaDialog();
      });
    }
  }

  void _showVefaDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF064E3B);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF334155);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'vefa_reminder_title'.tr(),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        content: Text(
          'vefa_reminder_body'.tr(),
          style: TextStyle(
            fontFamily: 'Cairo',
            color: textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                color: textColor.withOpacity(0.7),
              ),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.diversity_1, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              _showVefaSelectionSheet();
            },
            label: Text(
              'gift_thawab'.tr(),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVefaSelectionSheet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VefaPage(isSelectionMode: true),
        fullscreenDialog: true, // Make it look like a modal
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final azkarAsync = ref.watch(azkarDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryColor = const Color(0xFF064E3B);
    final accentColor = const Color(0xFFD97706);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF334155);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SilaAppBar(
        title: widget.title,
      ),
      body: azkarAsync.when(
        data: (data) {
          final items = data[widget.categoryId] ?? [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                "Coming soon...",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: subtitleColor,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              final currentCount = _counts[index] ?? 0;
              final isCompleted = currentCount >= item.count;
              final progress = (item.count > 0) ? currentCount / item.count : 0.0;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isCompleted ? 0.6 : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: isCompleted
                          ? null
                          : () {
                              setState(() {
                                _counts[index] = currentCount + 1;
                              });
                              if (_counts[index]! >= item.count) {
                                _checkCompletion(items);
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Top Row: Count Badge & Info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${item.count}",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (item.fadilah.isNotEmpty)
                                  Icon(Icons.info_outline, color: accentColor, size: 24),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Azkar Text
                            Text(
                              item.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Amiri", // Use Arabic font for Zikr
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 1.8,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Fadilah
                            if (item.fadilah.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.fadilah,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    color: subtitleColor,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            Divider(color: subtitleColor.withOpacity(0.2)),
                            const SizedBox(height: 16),
                            // Progress Ring
                            CircularPercentIndicator(
                              radius: 36.0,
                              lineWidth: 6.0,
                              percent: progress > 1.0 ? 1.0 : progress,
                              center: Text(
                                "${item.count - currentCount}",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: textColor,
                                ),
                              ),
                              progressColor: primaryColor,
                              backgroundColor: primaryColor.withOpacity(0.1),
                              circularStrokeCap: CircularStrokeCap.round,
                              animation: true,
                              animateFromLastPercent: true,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "tap_to_count".tr(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (e, st) => Center(
          child: Text(
            "Error: $e",
            style: TextStyle(color: Colors.redAccent, fontFamily: 'Cairo'),
          ),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      ),
    );
  }
}
