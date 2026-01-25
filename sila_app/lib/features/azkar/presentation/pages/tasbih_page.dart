import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple StateProvider for the counter
final tasbihCounterProvider = StateProvider.autoDispose<int>((ref) => 0);

class TasbihPage extends ConsumerWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(tasbihCounterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('azkar_tasbih'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(tasbihCounterProvider.notifier).state = 0;
              HapticFeedback.heavyImpact();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: InkWell(
        onTap: () {
          ref.read(tasbihCounterProvider.notifier).state++;
          HapticFeedback.lightImpact();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$count",
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Tap anywhere to count", // Could be localized
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
            // Bottom control mock
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: const Center(
                child: Icon(Icons.touch_app_rounded, size: 40, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
