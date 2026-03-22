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
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
            final ayahs = surah.ayahs ?? [];
            if (ayahs.isEmpty) {
              return Center(
                child: Text(
                  'جاري التحميل...',
                  style: TextStyle(color: txtP),
                ),
              );
            }

            // Group ayahs into pages (يتم حسابها بناءً على حجم الخط والمساحة المتاحة)
            final pages = _groupAyahsIntoPages(ayahs, settings.fontSize);
            final totalAyahs = ayahs.length;
            final autoPlayState = ref.watch(surahAutoPlayControllerProvider(totalAyahs));

            return Stack(
              children: [
                // PageView for pages
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, pageIndex) {
                    final pageAyahs = pages[pageIndex];
                    return _buildQuranPage(
                      pageAyahs,
                      settings,
                      primaryColor,
                      txtP,
                      txtS,
                      surface,
                      isDark,
                      playingAyahId,
                      autoPlayState,
                      widget.surahNumber,
                      widget.surahName,
                    );
                  },
                ),

                // AppBar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF064E3B),
                    elevation: 0,
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
                      IconButton(
                        icon: Icon(
                          autoPlayState.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                        tooltip: autoPlayState.isPlaying ? 'إيقاف مؤقت' : 'تشغيل السورة',
                        onPressed: () => _handleAutoPlayToggle(
                          ref,
                          widget.surahNumber,
                          widget.surahName,
                          totalAyahs,
                          autoPlayState,
                        ),
                      ),
                      const SizedBox(width: 4),
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
                ),

                // Page indicator at bottom
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'الصفحة ${_currentPage + 1} من ${pages.length}',
                        style: GoogleFonts.getFont(
                          'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, _) => Center(
            child: Text(
              'خطأ: $error',
              style: TextStyle(color: txtP),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF064E3B)),
          ),
        ),
      ),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('خطأ في تحميل الإعدادات: $error'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  /// Group ayahs into pages based on font size and screen height
  List<List<dynamic>> _groupAyahsIntoPages(dynamic ayahs, double fontSize) {
    final pages = <List<dynamic>>[];
    final ayahsPerPage = _calculateAyahsPerPage(fontSize);

    for (int i = 0; i < ayahs.length; i += ayahsPerPage) {
      final end = (i + ayahsPerPage < ayahs.length) ? i + ayahsPerPage : ayahs.length;
      pages.add(ayahs.sublist(i, end));
    }

    return pages;
  }

  /// Calculate how many ayahs fit per page based on font size
  int _calculateAyahsPerPage(double fontSize) {
    // الصيغة: 50 - (fontSize * 0.5)
    // مثلاً: حجم خط 24 = 50 - 12 = 38 آية تقريباً
    // حجم خط 32 = 50 - 16 = 34 آية تقريباً
    return ((50 - (fontSize * 0.5)).toInt()).clamp(8, 50);
  }

  /// Build a single page of Quran
  Widget _buildQuranPage(
    List<dynamic> pageAyahs,
    QuranSettings settings,
    Color primaryColor,
    Color txtP,
    Color txtS,
    Color surface,
    bool isDark,
    int? playingAyahId,
    AutoPlayState autoPlayState,
    int surahNumber,
    String surahName,
  ) {
    return Container(
      color: surface,
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 100),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Bismillah at top of first page only
            if (_currentPage == 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Amiri',
                    fontSize: 28,
                    color: primaryColor,
                    height: 2.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // Ayahs on this page
            ...pageAyahs.map((ayah) {
              final isPlaying = playingAyahId == ayah.number;
              final isAutoPlayCurrent = autoPlayState.isPlaying &&
                  autoPlayState.currentAyahNumber == ayah.number;

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Ayah text with number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ayah number in circle
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0.1),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${ayah.number}',
                            style: GoogleFonts.getFont(
                              'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Ayah text
                        Expanded(
                          child: Text(
                            ayah.text,
                            textAlign: TextAlign.right,
                            textDirection: ui.TextDirection.rtl,
                            style: GoogleFonts.getFont(
                              settings.fontFamily,
                              fontSize: settings.fontSize - 2,
                              height: 2.2,
                              fontWeight: FontWeight.w600,
                              color: isAutoPlayCurrent
                                  ? primaryColor
                                  : (isPlaying ? primaryColor.withOpacity(0.8) : txtP),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Play button and translation (if available)
                    if (ayah.translation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, right: 44),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
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
                              fontSize: (settings.fontSize - 4).clamp(10, 48),
                              height: 1.8,
                              color: txtS,
                            ),
                          ),
                        ),
                      ),

                    // Play button
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 44),
                      child: _buildPlayButton(
                        context,
                        ref,
                        surahNumber,
                        ayah.number,
                        surahName,
                        isPlaying,
                        primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Build play button for individual ayah
  Widget _buildPlayButton(
    BuildContext context,
    WidgetRef ref,
    int surahNumber,
    int ayahNumber,
    String surahName,
    bool isPlaying,
    Color primaryColor,
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
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPlaying ? primaryColor.withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          size: 16,
          color: primaryColor,
        ),
      ),
    );
  }

  /// Auto-play toggle handler
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
          await controller.resumeAutoPlay(surahNumber, surahName);
        } else {
          await controller.pauseAutoPlay();
        }
      } else {
        await controller.startAutoPlay(surahNumber, 1, totalAyahs, surahName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  /// Show settings dialog
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
              Text(
                'إعدادات القراءة',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: txtP,
                ),
              ),
              const SizedBox(height: 32),

              // Reciter selection
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
                            'اختر القارئ',
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

              // Font selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_fields, color: primaryColor, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'نوع الخط',
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
                        value: 'Amiri',
                        child: Text(
                          'Amiri (ميري)',
                          style: GoogleFonts.getFont('Amiri'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Noto Naskh Arabic',
                        child: Text(
                          'Noto Naskh',
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

              // Font size
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
                            'حجم الخط',
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

  /// Detect translation text direction
  ui.TextDirection _getTranslationDirection(String text) {
    if (text.isEmpty) return ui.TextDirection.ltr;
    final firstChar = text.codeUnitAt(0);
    if (firstChar >= 0x0600 && firstChar <= 0x06FF) {
      return ui.TextDirection.rtl;
    }
    return ui.TextDirection.ltr;
  }
}
