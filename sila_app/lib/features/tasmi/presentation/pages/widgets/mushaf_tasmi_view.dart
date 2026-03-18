
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
    final words = ref.watch(tasmiControllerProvider.select((s) => s.words));
    final theme = Theme.of(context);

    // --- PLACEHOLDER: Replace with your actual settings provider ---
    const fontFamily = 'Amiri';
    const fontSize = 24.0;
    // --- END PLACEHOLDER ---

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          style: GoogleFonts.getFont(
            fontFamily,
            fontSize: fontSize,
            height: 2.2,
            color: theme.textTheme.bodyLarge?.color,
          ),
          children: _buildTextSpans(words, theme, fontFamily, fontSize),
        ),
      ),
    );
  }

  List<InlineSpan> _buildTextSpans(
    List<TasmiWordEntry> words,
    ThemeData theme,
    String fontFamily,
    double fontSize,
  ) {
    final List<InlineSpan> spans = [];
    if (words.isEmpty) return spans;

    for (int i = 0; i < words.length; i++) {
      final entry = words[i];
      
      if (entry.status == WordEntryStatus.hidden) {
        // ROOT CAUSE FIX: Use Opacity widget to reliably reserve space.
        spans.add(
          WidgetSpan(
            child: Opacity(
              opacity: 0,
              child: Text(
                entry.word,
                style: GoogleFonts.getFont(fontFamily, fontSize: fontSize, height: 2.2),
              ),
            ),
          ),
        );
        spans.add(const TextSpan(text: ' '));
      } else {
        spans.add(
          TextSpan(
            text: '${entry.word} ',
            style: _getWordStyle(entry.status, theme),
          ),
        );
      }

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

  TextStyle _getWordStyle(WordEntryStatus status, ThemeData theme) {
    switch (status) {
      case WordEntryStatus.correct:
        return TextStyle(color: theme.primaryColor);
      case WordEntryStatus.closeError:
        return const TextStyle(color: Colors.amber);
      case WordEntryStatus.wrongWord:
        return TextStyle(
          color: const Color(0xFFA32D2D),
          backgroundColor: const Color(0xFFA32D2D).withOpacity(0.15),
        );
      case WordEntryStatus.hidden:
        // This case is now handled by the Opacity widget.
        return const TextStyle(); 
    }
  }

  Widget _buildAyahNumber(int number, ThemeData theme, double fontSize) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primaryColor.withOpacity(0.15),
        border: Border.all(color: theme.primaryColor, width: 1),
      ),
      child: Text(
        _toArabicNumber(number.toString()),
        style: TextStyle(
          color: theme.primaryColor,
          fontSize: fontSize * 0.6,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
