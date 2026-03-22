import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/presentation/widgets/reciter_picker_sheet.dart';
import 'package:sila_app/core/providers/reciter_provider.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';
import 'package:sila_app/features/quran/presentation/riverpod/audio_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_settings_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/surah_autoplay_controller.dart';

class SurahDetailPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  ConsumerState<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends ConsumerState<SurahDetailPage> {
  @override
  Widget build(BuildContext context) {
    final surahState = ref.watch(surahDetailControllerProvider(widget.surahNumber));
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
        body: surahState.when(
          data: (surah) {
            final totalAyahs = surah.ayahs?.length ?? 0;
            final autoPlayState = ref.watch(surahAutoPlayControllerProvider(totalAyahs));

            if (surah.ayahs == null || surah.ayahs!.isEmpty) {
              return Center(
                child: Text(
                  "جاري التحميل...",
                  style: TextStyle(color: txtP),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF064E3B),
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: Text(
                    widget.surahName,
                    style: GoogleFonts.getFont(
                      'Amiri',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                   actions: [
                     // Auto-play button (play/pause entire surah)
                     IconButton(
                       icon: Icon(
                         autoPlayState.isPlaying
                             ? Icons.pause_circle
                             : Icons.play_circle_outline,
                         color: Colors.white,
                         size: 28,
                       ),
                       tooltip: autoPlayState.isPlaying
                           ? 'إيقاف مؤقت'
                           : 'تشغيل السورة',
                       onPressed: () => _handleAutoPlayToggle(
                         ref,
                         widget.surahNumber,
                         widget.surahName,
                         totalAyahs,
                         autoPlayState,
                       ),
                     ),
                     const SizedBox(width: 4),
                     // Settings (includes reciter picker)
                     IconButton(
                       icon: const Icon(Icons.tune_rounded, color: Colors.white),
                       onPressed: () => _showSettingsDialog(
                         context,
                         ref,
                         settings,
                         isDark,
                         surface,
                         txtP,
                         primaryColor,
                       ),
                       tooltip: 'الإعدادات',
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

                // Ayahs List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final ayah = surah.ayahs![i];
                        final isPlaying = playingAyahId == ayah.number;
                        final isAutoPlayCurrent = autoPlayState.isPlaying &&
                            autoPlayState.currentAyahNumber == ayah.number;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isAutoPlayCurrent
                                  ? primaryColor.withOpacity(0.5)
                                  : (isPlaying
                                      ? primaryColor.withOpacity(0.3)
                                      : border),
                              width: isAutoPlayCurrent ? 2 : (isPlaying ? 1 : 0.5),
                            ),
                            boxShadow: isAutoPlayCurrent
                                ? [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Ayah number and play button (top row)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Play individual ayah button
                                  _buildPlayButton(
                                    context,
                                    ref,
                                    widget.surahNumber,
                                    ayah.number,
                                    widget.surahName,
                                    isPlaying,
                                    primaryColor,
                                    border,
                                  ),
                                  // Ayah number badge
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${ayah.number}',
                                        style: GoogleFonts.getFont(
                                          'Cairo',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Ayah text (Arabic)
                              Text(
                                ayah.text,
                                textAlign: TextAlign.right,
                                textDirection: ui.TextDirection.rtl,
                                style: GoogleFonts.getFont(
                                  settings.fontFamily,
                                  fontSize: settings.fontSize,
                                  height: 2.2,
                                  fontWeight: FontWeight.w600,
                                  color: txtP,
                                ),
                              ),

                               // Translation (only if available)
                               if (ayah.translation.isNotEmpty) ...[
                                 const SizedBox(height: 16),
                                 Container(
                                   padding: const EdgeInsets.all(14),
                                   decoration: BoxDecoration(
                                     color: primaryColor.withOpacity(0.05),
                                     borderRadius: BorderRadius.circular(12),
                                     border: Border.all(
                                       color: primaryColor.withOpacity(0.1),
                                       width: 1,
                                     ),
                                   ),
                                   child: Text(
                                     ayah.translation,
                                     textAlign: TextAlign.start,
                                     textDirection: _getTranslationDirection(ayah.translation),
                                     style: GoogleFonts.getFont(
                                       'Cairo',
                                       fontSize: 14,
                                       height: 1.8,
                                       color: txtS,
                                     ),
                                   ),
                                 ),
                               ],
                            ],
                          ),
                        );
                      },
                      childCount: surah.ayahs!.length,
                    ),
                  ),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            );
          },
          error: (error, _) => Center(
            child: Text(
              'Error: $error',
              style: TextStyle(color: txtP),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF064E3B)),
          ),
        ),
      ),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Error loading settings: $error'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  /// Build individual ayah play button
  Widget _buildPlayButton(
    BuildContext context,
    WidgetRef ref,
    int surahNumber,
    int ayahNumber,
    String surahName,
    bool isPlaying,
    Color primaryColor,
    Color border,
  ) {
    return GestureDetector(
      onTap: () async {
        try {
          if (isPlaying) {
            await ref.read(audioControllerProvider.notifier).stopAudio();
            ref.read(playingAyahIdProvider.notifier).setPlaying(null);
          } else {
            ref.read(playingAyahIdProvider.notifier).setPlaying(ayahNumber);
            final audioController = ref.read(audioControllerProvider.notifier);
            final url = ref
                .read(reciterControllerProvider.notifier)
                .buildAyahUrl(surahNumber, ayahNumber);
            await audioController.playAudio(
              url,
              surahName: surahName,
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
            );
          }
        } catch (e) {
          ref.read(playingAyahIdProvider.notifier).setPlaying(null);
          if (!context.mounted) return;
          _showErrorDialog(
            context,
            const Color(0xFF0F172A),
            Colors.white,
            primaryColor,
          );
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isPlaying
              ? primaryColor.withOpacity(0.15)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: border),
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          size: 18,
          color: primaryColor,
        ),
      ),
    );
  }

  /// Handle auto-play toggle (play entire surah)
  Future<void> _handleAutoPlayToggle(
    WidgetRef ref,
    int surahNumber,
    String surahName,
    int totalAyahs,
    AutoPlayState autoPlayState,
  ) async {
    try {
      final controller = ref.read(
        surahAutoPlayControllerProvider(totalAyahs).notifier,
      );

      if (autoPlayState.isPlaying) {
        if (autoPlayState.isPaused) {
          // Resume
          await controller.resumeAutoPlay(surahNumber, surahName);
        } else {
          // Pause
          await controller.pauseAutoPlay();
        }
      } else {
        // Start from beginning
        await controller.startAutoPlay(
          surahNumber,
          1,
          totalAyahs,
          surahName,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
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
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                "إعدادات القراءة",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: txtP,
                ),
              ),
              const SizedBox(height: 32),

              // Reciter Selection Button
              GestureDetector(
                onTap: () => showReciterPickerSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mic_rounded, color: primaryColor, size: 24),
                          const SizedBox(width: 16),
                          Text(
                            "اختر القارئ",
                            style: GoogleFonts.getFont(
                              'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: txtP,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: primaryColor.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Font Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_fields, color: primaryColor, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        "نوع الخط",
                        style: GoogleFonts.getFont(
                          'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: txtP,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: const ['Amiri', 'Noto Naskh Arabic']
                            .contains(settings.fontFamily)
                        ? settings.fontFamily
                        : 'Amiri',
                    dropdownColor: surface,
                    style: GoogleFonts.getFont('Cairo', color: txtP),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      labelStyle: GoogleFonts.getFont('Cairo', color: txtP),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "Amiri",
                        child: Text(
                          "Amiri (ميري)",
                          style: GoogleFonts.getFont('Amiri'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Noto Naskh Arabic",
                        child: Text(
                          "Noto Naskh",
                          style: GoogleFonts.getFont('Noto Naskh Arabic'),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(quranSettingsControllerProvider.notifier)
                            .updateFontFamily(val);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Font Size Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.format_size, color: primaryColor, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            "حجم الخط",
                            style: GoogleFonts.getFont(
                              'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: txtP,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${settings.fontSize.toStringAsFixed(0)}',
                          style: GoogleFonts.getFont(
                            'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: settings.fontSize,
                    min: 16,
                    max: 48,
                    divisions: 16,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withOpacity(0.2),
                    onChanged: (val) {
                      ref
                          .read(quranSettingsControllerProvider.notifier)
                          .updateFontSize(val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(
    BuildContext context,
    Color txtP,
    Color surface,
    Color primaryColor,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surface,
        title: Text(
          "خطأ في تشغيل الصوت",
          style: GoogleFonts.getFont('Cairo', color: txtP),
        ),
        content: Text(
          "عذراً، لا يمكن تشغيل الصوت حالياً.",
          style: GoogleFonts.getFont('Cairo', color: txtP),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              "حسناً",
              style: GoogleFonts.getFont('Cairo', color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Detect translation text direction (RTL for Arabic, LTR for Turkish/English)
  ui.TextDirection _getTranslationDirection(String text) {
    if (text.isEmpty) return ui.TextDirection.ltr;
    
    // Check first character for Arabic/Persian/Urdu scripts
    final firstChar = text.codeUnitAt(0);
    
    // Arabic Unicode range: 0x0600 - 0x06FF
    // Persian/Urdu: 0x0600 - 0x06FF
    if (firstChar >= 0x0600 && firstChar <= 0x06FF) {
      return ui.TextDirection.rtl;
    }
    
    // Turkish, English, and other LTR languages
    return ui.TextDirection.ltr;
  }
}
