import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_settings_controller.dart';
import 'package:sila_app/features/wird/presentation/riverpod/wird_controller.dart';

class WirdReaderPage extends ConsumerStatefulWidget {
  final int startPage;
  final int endPage; 

  const WirdReaderPage({
    super.key,
    required this.startPage,
    required this.endPage,
  });

  @override
  ConsumerState<WirdReaderPage> createState() => _WirdReaderPageState();
}

class _WirdReaderPageState extends ConsumerState<WirdReaderPage> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.startPage;
    _pageController = PageController(initialPage: widget.startPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final newPage = index + 1;
    setState(() {
      _currentPage = newPage;
    });
    ref.read(wirdControllerProvider.notifier).updateCurrentPage(newPage);
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(quranSettingsControllerProvider);
    final isDone = _currentPage >= widget.endPage;

    return settingsState.when(
      data: (settings) {
        final surahData = quran.getPageData(_currentPage);
        final currentSurah = surahData.isNotEmpty ? surahData[0]['surah'] : 1;
        final currentJuz = quran.getJuzNumber(_currentPage, 1);
        final surahName = quran.getSurahNameArabic(currentSurah);

        return Scaffold(
          backgroundColor: _getBackgroundColor(settings.themeMode),
          appBar: _buildCustomAppBar(settings, surahName, currentJuz, isDone),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl, // Ensure RTL for Quran
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 604,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        final pageNum = index + 1;
                        return _buildQuranPage(pageNum, settings);
                      },
                    ),
                  ),
                ),
                // Bottom Slider
                _buildBottomSlider(settings),
              ],
            ),
          ),
        );
      },
      error: (e, s) => Scaffold(body: Center(child: Text("Error: $e"))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(QuranSettings settings, String surahName, int juz, bool isDone) {
    final isDarkSettings = settings.themeMode == QuranThemeMode.dark;
    final appBarBg = isDarkSettings ? const Color(0xFF1A1A1A) : const Color(0xFF333333); 
    final iconColor = Colors.white;

    return AppBar(
      backgroundColor: appBarBg,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'سورة $surahName',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Amiri',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'صفحة $_currentPage، جزء $juz',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        if (isDone)
           IconButton(
             icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
             onPressed: () => Navigator.pop(context, true),
             tooltip: 'أتممت الورد',
           ),
        IconButton(
          icon: Icon(Icons.bookmark_border, color: iconColor),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ في العلامات المرجعية')));
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: iconColor),
          onPressed: () => _showSettingsDialog(context, ref, settings),
        ),
      ],
    );
  }

  Widget _buildBottomSlider(QuranSettings settings) {
    return Container(
      color: _getBackgroundColor(settings.themeMode),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '604',
            style: TextStyle(color: _getTextColor(settings.themeMode), fontSize: 12),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                value: _currentPage.toDouble(),
                min: 1,
                max: 604,
                activeColor: _getAccentColor(settings.themeMode),
                inactiveColor: _getTextColor(settings.themeMode).withOpacity(0.2),
                onChanged: (val) {
                  final newPage = val.toInt();
                  if (newPage != _currentPage) {
                    _pageController.jumpToPage(newPage - 1);
                  }
                },
              ),
            ),
          ),
          Text(
            '1',
            style: TextStyle(color: _getTextColor(settings.themeMode), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuranPage(int pageNumber, QuranSettings settings) {
    final pageData = quran.getPageData(pageNumber);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
             for (var data in pageData) ...[
                _buildSurahSegment(data['surah'], data['start'], data['end'], settings),
             ]
        ],
      ),
    );
  }

  Widget _buildSurahSegment(int surahNum, int startAyah, int endAyah, QuranSettings settings) {
    String versesText = "";
    for (int i = startAyah; i <= endAyah; i++) {
      versesText += "${quran.getVerse(surahNum, i)} ﴿${_arabicNumber(i)}﴾ ";
    }
    
    return Column(
      children: [
        if (startAyah == 1) ...[ 
           _buildBismillahFrame(surahNum, settings),
           if (surahNum != 1 && surahNum != 9) 
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 16.0),
               child: Text(
                 "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", 
                 style: TextStyle(fontFamily: 'Amiri', fontSize: 24, color: _getTextColor(settings.themeMode)),
               ),
             ), 
        ],
        
        Text(
          versesText,
          textAlign: TextAlign.justify,
          textDirection: ui.TextDirection.rtl,
          style: GoogleFonts.getFont(
            settings.fontFamily,
            fontSize: settings.fontSize,
            height: 2.2, // Match the typical mushaf spacing
            color: _getTextColor(settings.themeMode),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _arabicNumber(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String numStr = number.toString();
    for (int i = 0; i < english.length; i++) {
      numStr = numStr.replaceAll(english[i], arabic[i]);
    }
    return numStr;
  }

  Widget _buildBismillahFrame(int surahNum, QuranSettings settings) {
    final isDark = settings.themeMode == QuranThemeMode.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF3EFE9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getAccentColor(settings.themeMode).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(Icons.spa_outlined, color: _getAccentColor(settings.themeMode), size: 18),
           const SizedBox(width: 8),
           Text(
             "سورة ${quran.getSurahNameArabic(surahNum)}",
             textAlign: TextAlign.center,
             style: TextStyle(
               fontFamily: 'Amiri', 
               fontSize: 24, 
               fontWeight: FontWeight.bold,
               color: _getTextColor(settings.themeMode)
             ),
           ),
           const SizedBox(width: 8),
           Icon(Icons.spa_outlined, color: _getAccentColor(settings.themeMode), size: 18),
        ],
      ),
    );
  }

  // --- Settings Helpers ---
  Color _getBackgroundColor(QuranThemeMode mode) {
    switch (mode) {
      case QuranThemeMode.light:
        return const Color(0xFFFAFAFA); // Standard white/off-white
      case QuranThemeMode.dark:
        return const Color(0xFF141414); // Pure dark theme
      case QuranThemeMode.sepia:
        return const Color(0xFFFBF4E4); // Book page color
    }
  }

  Color _getTextColor(QuranThemeMode mode) {
    switch (mode) {
      case QuranThemeMode.light:
        return Colors.black87;
      case QuranThemeMode.dark:
        return const Color(0xFFE0E0E0);
      case QuranThemeMode.sepia:
        return const Color(0xFF4A3B32);
    }
  }

  Color _getAccentColor(QuranThemeMode mode) {
    switch (mode) {
      case QuranThemeMode.light:
        return const Color(0xFF2E7D32); // Deep emerald
      case QuranThemeMode.dark:
        return const Color(0xFF81C784); // Lighter green
      case QuranThemeMode.sepia:
        return const Color(0xFF795548); // Brownish matching sepia
    }
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref, QuranSettings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _getBackgroundColor(settings.themeMode),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getTextColor(settings.themeMode),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildThemeOption(ref, QuranThemeMode.light, "فاتح", settings),
                _buildThemeOption(ref, QuranThemeMode.sepia, "كتابي", settings),
                _buildThemeOption(ref, QuranThemeMode.dark, "داكن", settings),
              ],
            ),
            const SizedBox(height: 32),
            DropdownButtonFormField<String>(
              value: settings.fontFamily,
              dropdownColor: _getBackgroundColor(settings.themeMode),
              style: TextStyle(color: _getTextColor(settings.themeMode)),
              decoration: InputDecoration(
                labelText: "نوع الخط",
                labelStyle: TextStyle(color: _getTextColor(settings.themeMode)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [
                const DropdownMenuItem(value: "Amiri", child: Text("Amiri (أميري)")),
                const DropdownMenuItem(value: "Noto Naskh Arabic", child: Text("Noto Naskh")),
                const DropdownMenuItem(value: "Scheherazade New", child: Text("Scheherazade")),
              ],
              onChanged: (val) {
                if (val != null) {
                  ref.read(quranSettingsControllerProvider.notifier).updateFontFamily(val);
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.format_size, color: _getTextColor(settings.themeMode)),
                Expanded(
                  child: Slider(
                    value: settings.fontSize,
                    min: 20,
                    max: 44,
                    divisions: 12,
                    activeColor: _getAccentColor(settings.themeMode),
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

  Widget _buildThemeOption(WidgetRef ref, QuranThemeMode mode, String label, QuranSettings settings) {
    final isSelected = settings.themeMode == mode;
    return GestureDetector(
      onTap: () => ref.read(quranSettingsControllerProvider.notifier).updateThemeMode(mode),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getBackgroundColor(mode),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? _getAccentColor(settings.themeMode) : Colors.grey,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: _getTextColor(settings.themeMode),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
