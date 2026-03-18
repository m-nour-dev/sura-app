
import 'package:flutter/material.dart';

class TasmiCorrectionBubble extends StatelessWidget {
  final String? word;

  const TasmiCorrectionBubble({super.key, this.word});

  @override
  Widget build(BuildContext context) {
    if (word == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'الكلمة الصحيحة',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onErrorContainer.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            word!,
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onErrorContainer,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 6),
          Text(
            'جار المتابعة...',
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onErrorContainer.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
