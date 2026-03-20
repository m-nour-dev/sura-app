import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';
import 'package:sila_app/features/quran/presentation/riverpod/audio_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_settings_controller.dart';

class SurahDetailPage extends ConsumerWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahState = ref.watch(surahDetailControllerProvider(surahNumber));
    final settingsState = ref.watch(quranSettingsControllerProvider);
    final playingAyahId = ref.watch(playingAyahIdProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFDFBF7);
    final surface = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? Colors.white12 : const Color(0xFFE2E8F0);
    final txtP = isDark ? Colors.white : const Color(0xFF0F172A);
    final txtS = isDark ? Colors.white60 : const Color(0xFF64748B);
    const primaryColor = Color(0xFF064E3B);

    return settingsState.when(
      data: (settings) => Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF064E3B),
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                surahName,
                style: GoogleFonts.getFont(
                  'Amiri',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.tune_rounded, color: Colors.white),
                  onPressed: () => _showSettingsDialog(context, ref, settings, isDark, surface, txtP, primaryColor),
                ),
              ],
            ),

            // Bismillah
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Amiri',
                    fontSize: 24,
                    color: primaryColor,
                    height: 2.0,
                  ),
                ),
              ),
            ),

            // Ayahs
            surahState.when(
              data: (surah) {
                if (surah.ayahs == null || surah.ayahs!.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        "جاري التحميل...",
                        style: TextStyle(color: txtP),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final ayah = surah.ayahs![i];
                        final isPlaying = playingAyahId == ayah.number;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isPlaying ? primaryColor.withOpacity(0.3) : border,
                              width: isPlaying ? 1 : 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // نص الآية
                              Text(
                                ayah.text,
                                textAlign: TextAlign.right,
                                textDirection: ui.TextDirection.rtl,
                                style: GoogleFonts.getFont(
                                  settings.fontFamily,
                                  fontSize: settings.fontSize,
                                  height: 2.2,
                                  color: txtP,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Translation if available
                              if (ayah.translation.isNotEmpty) ...[
                                Text(
                                  ayah.translation,
                                  textAlign: TextAlign.right,
                                  textDirection: ui.TextDirection.rtl,
                                  style: GoogleFonts.getFont(
                                    'Cairo',
                                    fontSize: 14,
                                    height: 1.6,
                                    color: txtS,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                              // Row: رقم الآية + زر الصوت
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // زر الصوت
                                  GestureDetector(
                                    onTap: () async {
                                      if (ayah.audioUrl != null) {
                                        try {
                                          if (isPlaying) {
                                            ref.read(playingAyahIdProvider.notifier).setPlaying(null);
                                            // Handle pause if audioController supports it
                                          } else {
                                            ref.read(playingAyahIdProvider.notifier).setPlaying(ayah.number);
                                            final audioController = ref.read(audioControllerProvider.notifier);
                                            await audioController.playAudio(
                                              ayah.audioUrl!,
                                              surahName: surahName,
                                              ayahNumber: ayah.number,
                                            );
                                          }
                                        } catch (e) {
                                          ref.read(playingAyahIdProvider.notifier).setPlaying(null);
                                          if (!context.mounted) return;
                                          _showErrorDialog(context, txtP, surface, primaryColor);
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: isPlaying
                                            ? primaryColor.withOpacity(0.15)
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: border),
                                      ),
                                      child: Icon(
                                        isPlaying ? Icons.pause : Icons.play_arrow,
                                        size: 14,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  // رقم الآية
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${ayah.number}',
                                        style: GoogleFonts.getFont(
                                          'Cairo',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: surah.ayahs!.length,
                    ),
                  ),
                );
              },
              error: (error, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $error', style: TextStyle(color: txtP))),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: primaryColor)),
              ),
            ),
          ],
        ),
      ),
      error: (error, _) => Scaffold(body: Center(child: Text('Error loading settings: $error'))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  void _showSettingsDialog(
    BuildContext context,
    WidgetRef ref,
    QuranSettings settings,
    bool isDark,
    Color surface,
    Color txtP,
    Color primaryColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "إعدادات القراءة",
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: txtP,
              ),
            ),
            const SizedBox(height: 32),
            // Font Selection
            DropdownButtonFormField<String>(
              value: settings.fontFamily,
              dropdownColor: surface,
              style: GoogleFonts.getFont('Cairo', color: txtP),
              decoration: InputDecoration(
                labelText: "نوع الخط",
                labelStyle: GoogleFonts.getFont('Cairo', color: txtP),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [
                DropdownMenuItem(value: "Amiri", child: Text("Amiri (ميري)", style: GoogleFonts.getFont('Amiri'))),
                DropdownMenuItem(value: "Noto Naskh Arabic", child: Text("Noto Naskh", style: GoogleFonts.getFont('Noto Naskh Arabic'))),
              ],
              onChanged: (val) {
                if (val != null) {
                  ref.read(quranSettingsControllerProvider.notifier).updateFontFamily(val);
                }
              },
            ),
            const SizedBox(height: 24),
            // Font Size
            Row(
              children: [
                Icon(Icons.format_size, color: txtP),
                Expanded(
                  child: Slider(
                    value: settings.fontSize,
                    min: 16,
                    max: 48,
                    divisions: 10,
                    activeColor: primaryColor,
                    onChanged: (val) {
                      ref.read(quranSettingsControllerProvider.notifier).updateFontSize(val);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, Color txtP, Color surface, Color primaryColor) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surface,
        title: Text("خطأ في تشغيل الصوت", style: GoogleFonts.getFont('Cairo', color: txtP)),
        content: Text("عذراً، لا يمكن تشغيل الصوت حالياً.", style: GoogleFonts.getFont('Cairo', color: txtP)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text("حسناً", style: GoogleFonts.getFont('Cairo', color: primaryColor)),
          ),
        ],
      ),
    );
  }
}
