
import 'package:flutter/material.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_entry.dart';
import 'package:sila_app/features/tasmi/presentation/controllers/tasmi_controller.dart';

String _toArabicNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], arabic[i]);
  }
  return input;
}

class TasmiStatsRow extends StatelessWidget {
  final TasmiState state;
  const TasmiStatsRow({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    int correctCount = state.words.where((w) => w.status == WordEntryStatus.correct).length;
    int errorCount = state.words.where((w) => w.status == WordEntryStatus.closeError || w.status == WordEntryStatus.wrongWord).length;
    int currentAyah = state.words.isEmpty || state.currentIndex >= state.words.length
        ? 0
        : state.words[state.currentIndex].verseNumber;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(child: _StatCard(label: 'الآية', value: currentAyah > 0 ? _toArabicNumber(currentAyah.toString()) : '-')),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: 'خطأ', value: _toArabicNumber(errorCount.toString()), color: Colors.red)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: 'صحيح', value: _toArabicNumber(correctCount.toString()), color: Colors.green)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatCard({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5), width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color ?? theme.primaryColor),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color)),
        ],
      ),
    );
  }
}
