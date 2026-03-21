import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/presentation/widgets/sila_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Simple StateProvider for the counter
final tasbihCounterProvider = StateProvider.autoDispose<int>((ref) => 0);

class TasbihPage extends ConsumerStatefulWidget {
  const TasbihPage({super.key});

  @override
  ConsumerState<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends ConsumerState<TasbihPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    ref.read(tasbihCounterProvider.notifier).state++;
    HapticFeedback.lightImpact();
    
    // Trigger pulse animation
    _pulseController.forward().then((_) => _pulseController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(tasbihCounterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Sila Global Colors
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryColor = const Color(0xFF064E3B);
    final accentColor = const Color(0xFFD97706);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF334155);

    // Calculate progress (e.g., target 33)
    final int target = 33;
    final int progressCount = count % target;
    final double progress = progressCount / target;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SilaAppBar(
        title: 'azkar_tasbih'.tr(),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(tasbihCounterProvider.notifier).state = 0;
              HapticFeedback.heavyImpact();
            },
            icon: Icon(Icons.refresh_rounded, color: primaryColor),
            tooltip: 'Reset',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GestureDetector(
        onTap: _incrementCounter,
        behavior: HitTestBehavior.opaque, // Ensures tap anywhere works
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: surfaceColor,
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                      ],
                    ),
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 12.0,
                      percent: progress == 0 && count > 0 ? 1.0 : progress, // show full circle at 33, 66...
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 300,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: primaryColor,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$count",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 72,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Round ${count ~/ target + 1}",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Instruction Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 48,
                    color: primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tap anywhere to count", // Ideally localizable
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Target is 33", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}