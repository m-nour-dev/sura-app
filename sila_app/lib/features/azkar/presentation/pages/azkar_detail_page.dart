import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/azkar/data/models/azkar_model.dart';
import 'package:sila_app/features/azkar/presentation/riverpod/azkar_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    final azkarAsync = ref.watch(azkarDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: azkarAsync.when(
        data: (data) {
          final items = data[widget.categoryId] ?? [];
          if (items.isEmpty) {
            return const Center(child: Text("Start soon..."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              final currentCount = _counts[index] ?? 0;
              final isCompleted = currentCount >= item.count;
              final progress = (item.count > 0) ? currentCount / item.count : 0.0;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isCompleted ? 0.5 : 1.0,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isCompleted
                        ? null
                        : () {
                            setState(() {
                              _counts[index] = currentCount + 1;
                            });
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Header: Count Badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${item.count}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                              if (item.fadilah.isNotEmpty)
                                Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: 20),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Content
                          Text(
                            item.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              fontFamily: "Uthmanic", // Ensure font is used if available, or fallback
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (item.fadilah.isNotEmpty) ...[
                            Text(
                              item.fadilah,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.secondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          const Divider(),
                          const SizedBox(height: 8),
                          // Footer: Progress
                           CircularPercentIndicator(
                            radius: 30.0,
                            lineWidth: 5.0,
                            percent: progress > 1.0 ? 1.0 : progress,
                            center: Text(
                              "${item.count - currentCount}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            progressColor: Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                            animateFromLastPercent: true,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "tap_to_count".tr(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (e, st) => Center(child: Text("Error: $e")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
