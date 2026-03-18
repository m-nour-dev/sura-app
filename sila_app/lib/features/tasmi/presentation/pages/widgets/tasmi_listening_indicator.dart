import 'package:flutter/material.dart';

class TasmiListeningIndicator extends StatefulWidget {
  final bool isListening;

  const TasmiListeningIndicator({super.key, required this.isListening});

  @override
  State<TasmiListeningIndicator> createState() => _TasmiListeningIndicatorState();
}

class _TasmiListeningIndicatorState extends State<TasmiListeningIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) {
          controller.repeat(reverse: true);
        }
      });
      return controller;
    });

    _animations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0.3, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: widget.isListening
          ? Row(
              key: const ValueKey('listening'),
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  3,
                  (i) => AnimatedBuilder(
                    animation: _animations[i],
                    builder: (_, __) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: _animations[i].value),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'أستمع...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : Row(
              key: const ValueKey('paused'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mic_off_rounded, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  'متوقف مؤقتا',
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                ),
              ],
            ),
    );
  }
}
