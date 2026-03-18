import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_entry.dart';
import 'package:sila_app/features/tasmi/presentation/controllers/tasmi_controller.dart';

// Placeholder for your actual Quran Settings Provider
// import 'package:sila_app/features/settings/presentation/controllers/quran_settings_controller.dart';

String _toArabicNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], arabic[i]);
  }
  return input;
}

class MushafTasmiView extends ConsumerWidget {
  const MushafTasmiView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimization: Select only words and currentIndex to prevent rebuilding on other state changes
    final words = ref.watch(tasmiControllerProvider.select((state) => state.words));
    final currentIndex = ref.watch(tasmiControllerProvider.select((state) => state.currentIndex));
    final theme = Theme.of(context);
    const fontFamily = 'Amiri';
    const fontSize = 28.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.getFont(
                fontFamily,
                fontSize: fontSize,
                height: 2.2, // Generous line height for Mushaf aesthetics
                color: theme.textTheme.bodyLarge?.color,
              ),
              children: _buildTextSpans(words, currentIndex, theme, fontFamily, fontSize),
            ),
          ),
        ),
      ),
    );
  }

  List<InlineSpan> _buildTextSpans(
    List<TasmiWordEntry> words,
    int currentIndex,
    ThemeData theme,
    String fontFamily,
    double fontSize,
  ) {
    final List<InlineSpan> spans = [];
    if (words.isEmpty) return spans;

    for (int i = 0; i < words.length; i++) {
      final entry = words[i];
      final isCurrent = i == currentIndex;

      spans.add(
        TextSpan(
          text: '${entry.word} ',
          style: _getWordStyle(entry.status, isCurrent, theme),
        ),
      );

      bool isLastWordOfAyah = (i + 1 == words.length) || (words[i + 1].verseNumber != entry.verseNumber);

      if (isLastWordOfAyah) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _buildAyahNumber(entry.verseNumber, theme, fontSize),
          ),
        );
        spans.add(const TextSpan(text: ' '));
      }
    }
    return spans;
  }

  TextStyle _getWordStyle(WordEntryStatus status, bool isCurrent, ThemeData theme) {
    // Current word being recited gets a distinct highlight
    if (isCurrent) {
      return TextStyle(
        color: theme.colorScheme.primary, // Highlight color
        backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
        fontWeight: FontWeight.bold,
      );
    }

    switch (status) {
      case WordEntryStatus.correct:
        // Proper green for Mushaf success
        return const TextStyle(color: Color(0xFF2E7D32));
      case WordEntryStatus.closeError:
        return const TextStyle(color: Colors.amber);
      case WordEntryStatus.wrongWord:
        return TextStyle(
          color: const Color(0xFFA32D2D),
          backgroundColor: const Color(0xFFA32D2D).withOpacity(0.15),
        );
      case WordEntryStatus.hidden:
        // Completely invisible but retains perfect text shaping boundaries
        return const TextStyle(color: Colors.transparent);
    }
  }

  Widget _buildAyahNumber(int number, ThemeData theme, double fontSize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          _toArabicNumber(number.toString()),
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: fontSize * 0.45,
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
