import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/core/presentation/widgets/reciter_picker_sheet.dart';
import 'package:sila_app/core/providers/reciter_provider.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/core/utils/surah_utils.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';
import 'package:sila_app/features/quran/presentation/riverpod/audio_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_settings_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_data_provider.dart';
import 'package:sila_app/features/quran/presentation/widgets/quran_details_sheet.dart';
import 'package:sila_app/features/quran/presentation/utils/quran_ui_utils.dart';

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
  late int _currentPage;
  bool _isAudioBuffering = false;
  int? _selectedSurah;
  int? _selectedAyah;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _currentPage = quran.getPageNumber(widget.surahNumber, 1);
    _pageController = PageController(initialPage: _currentPage - 1);
    _loadBookmark();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBookmarked = prefs.getBool('bookmark_surah_${widget.surahNumber}') ?? false;
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isBookmarked = !_isBookmarked);
    await prefs.setBool('bookmark_surah_${widget.surahNumber}', _isBookmarked);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(quranSettingsControllerProvider);

    return settingsState.when(
      data: (settings) {
        final surahData = quran.getPageData(_currentPage);
        final firstSurahOnPage = surahData.isNotEmpty ? surahData[0]['surah'] as int : 1;
        final firstAyahOnPage = surahData.isNotEmpty ? surahData[0]['start'] as int : 1;
        final currentJuz = quran.getJuzNumber(firstSurahOnPage, firstAyahOnPage);
        final currentSurahName = SurahUtils.getLocalizedSurahName(context, firstSurahOnPage);

        return Scaffold(
          backgroundColor: QuranUIUtils.getBackgroundColor(settings.themeMode),
          appBar: _buildCustomAppBar(settings, currentSurahName, currentJuz),
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => setState(() {
                _selectedSurah = null;
                _selectedAyah = null;
              }),
              child: Column(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
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
                  _buildToolbar(context, ref, settings),
                  _buildBottomSlider(settings),
                ],
              ),
            ),
          ),
        );
      },
      error: (e, s) => Scaffold(body: Center(child: Text("Error: $e"))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(QuranSettings settings, String surahName, int juz) {
    final iconColor = QuranUIUtils.getTextColor(settings.themeMode);
    return AppBar(
      backgroundColor: QuranUIUtils.getBackgroundColor(settings.themeMode),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'surah_label'.tr(args: [surahName]),
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Amiri',
            ),
          ),
          Text(
            'page_with_juz_label'.tr(args: [
              _currentPage.toString(),
              juz.toString()
            ]),
            style: GoogleFonts.cairo(
              color: iconColor.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? AppTheme.accentColor : iconColor),
          onPressed: _toggleBookmark,
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: iconColor),
          onPressed: () => _showSettingsDialog(context, ref, settings),
        ),
      ],
    );
  }

  Widget _buildBottomSlider(QuranSettings settings) {
    return Container(
      color: QuranUIUtils.getBackgroundColor(settings.themeMode),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text('604', style: GoogleFonts.cairo(color: QuranUIUtils.getTextColor(settings.themeMode), fontSize: 12)),
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
                activeColor: QuranUIUtils.getAccentColor(settings.themeMode),
                inactiveColor: QuranUIUtils.getTextColor(settings.themeMode).withOpacity(0.2),
                onChanged: (val) {
                  final newPage = val.toInt();
                  if (newPage != _currentPage) {
                    _pageController.jumpToPage(newPage - 1);
                  }
                },
              ),
            ),
          ),
          Text('1', style: GoogleFonts.cairo(color: QuranUIUtils.getTextColor(settings.themeMode), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuranPage(int pageNumber, QuranSettings settings) {
    final pageData = quran.getPageData(pageNumber);
    final quranDataAsync = ref.watch(quranDataProvider);

    return quranDataAsync.when(
      data: (quranData) {
        final tajweedData = quranData.tajweed;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              for (var data in pageData) ...[
                _buildSurahSegment(data['surah'], data['start'], data['end'], settings, tajweedData),
              ]
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSurahSegment(int surahNum, int startAyah, int endAyah, QuranSettings settings, Map<String, String> tajweedData) {
    return Column(
      children: [
        if (startAyah == 1) ...[
          _buildBismillahFrame(surahNum, settings),
          if (surahNum != 1 && surahNum != 9)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 24,
                    color: QuranUIUtils.getTextColor(settings.themeMode)),
              ),
            ),
        ],
        Wrap(
          textDirection: ui.TextDirection.rtl,
          alignment: WrapAlignment.start,
          spacing: 2,
          runSpacing: 4,
          children: [
            for (int i = startAyah; i <= endAyah; i++)
              _buildAyahItem(surahNum, i, settings, tajweedData),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAyahItem(int surahNum, int ayahNum, QuranSettings settings, Map<String, String> tajweedData) {
    final key = '${surahNum}_$ayahNum';
    String rawVerse = tajweedData.containsKey(key) ? tajweedData[key]! : quran.getVerse(surahNum, ayahNum);
    rawVerse = "$rawVerse ﴿${QuranUIUtils.toArabicNumber(ayahNum)}﴾ ";
    final spans = QuranUIUtils.buildTajweedSpans(rawVerse, settings.themeMode);

    final bool isSelected = _selectedSurah == surahNum && _selectedAyah == ayahNum;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSurah = null; _selectedAyah = null;
          } else {
            _selectedSurah = surahNum; _selectedAyah = ayahNum;
          }
        });
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(color: const Color(0xFF064E3B).withOpacity(0.08), borderRadius: BorderRadius.circular(6))
            : const BoxDecoration(color: Colors.transparent),
        child: Text.rich(
          TextSpan(children: spans),
          textAlign: TextAlign.center,
          textDirection: ui.TextDirection.rtl,
          style: GoogleFonts.getFont(
            settings.fontFamily,
            fontSize: settings.fontSize,
            height: 2.2,
            color: QuranUIUtils.getTextColor(settings.themeMode),
          ),
        ),
      ),
    );
  }

  Widget _buildBismillahFrame(int surahNum, QuranSettings settings) {
    final isDark = settings.themeMode == QuranThemeMode.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurfaceColor : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: QuranUIUtils.getAccentColor(settings.themeMode).withOpacity(0.3), width: 1.5),
      ),
      child: Center(
        child: Text(
          'surah_label'.tr(args: [SurahUtils.getLocalizedSurahName(context, surahNum)]),
          style: TextStyle(fontFamily: 'Amiri', fontSize: 24, fontWeight: FontWeight.bold, color: QuranUIUtils.getTextColor(settings.themeMode)),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref, QuranSettings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: QuranUIUtils.getBackgroundColor(settings.themeMode),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("إعدادات القراءة", textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: QuranUIUtils.getTextColor(settings.themeMode))),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: Consumer(builder: (context, ref, child) {
                final reciterName = ref.watch(reciterControllerProvider).when(data: (r) => r.nameArabic, loading: () => "جاري...", error: (e, s) => "القارئ");
                return _buildSettingTile(icon: Icons.mic_rounded, label: reciterName, onTap: () => showReciterPickerSheet(context), settings: settings);
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildSettingTile(icon: Icons.info_outline, label: "عن السورة", onTap: () {}, settings: settings)),
            ]),
            const SizedBox(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildThemeOption(ref, QuranThemeMode.light, "فاتح", settings),
              _buildThemeOption(ref, QuranThemeMode.sepia, "كتابي", settings),
              _buildThemeOption(ref, QuranThemeMode.dark, "داكن", settings),
            ]),
            const SizedBox(height: 24),
            Row(children: [Icon(Icons.format_size, color: QuranUIUtils.getTextColor(settings.themeMode)), Expanded(child: Slider(value: settings.fontSize.clamp(16.0, 44.0), min: 16, max: 44, activeColor: QuranUIUtils.getAccentColor(settings.themeMode), onChanged: (v) => ref.read(quranSettingsControllerProvider.notifier).updateFontSize(v)))]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String label, required VoidCallback onTap, required QuranSettings settings}) {
    return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: settings.themeMode == QuranThemeMode.dark ? Colors.white10 : Colors.black12, borderRadius: BorderRadius.circular(12)), child: Column(children: [Icon(icon, color: QuranUIUtils.getAccentColor(settings.themeMode)), Text(label, style: GoogleFonts.cairo(fontSize: 12, color: QuranUIUtils.getTextColor(settings.themeMode)))])));
  }

  Widget _buildThemeOption(WidgetRef ref, QuranThemeMode mode, String label, QuranSettings settings) {
    final isSelected = settings.themeMode == mode;
    return GestureDetector(onTap: () => ref.read(quranSettingsControllerProvider.notifier).updateThemeMode(mode), child: Column(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: QuranUIUtils.getBackgroundColor(mode), shape: BoxShape.circle, border: Border.all(color: isSelected ? QuranUIUtils.getAccentColor(settings.themeMode) : Colors.grey))), Text(label, style: GoogleFonts.cairo(color: QuranUIUtils.getTextColor(settings.themeMode)))]));
  }

   Widget _buildToolbar(BuildContext context, WidgetRef ref, QuranSettings settings) {
     final isAnySelected = _selectedSurah != null && _selectedAyah != null;
     if (!isAnySelected) return const SizedBox.shrink();
     return Container(
       height: 60, margin: const EdgeInsets.all(16),
       decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))]),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           _toolbarAction(Icons.volume_up_rounded, 'toolbar_listen'.tr(), () => _playAyahAudio(_selectedSurah!, _selectedAyah!)),
           _toolbarAction(Icons.menu_book_rounded, 'toolbar_tafsir'.tr(), () => showQuranDetailsSheet(context, surahNumber: _selectedSurah!, ayahNumber: _selectedAyah!, showTafsir: true, settings: settings)),
           _toolbarAction(Icons.translate_rounded, 'toolbar_translation'.tr(), () => showQuranDetailsSheet(context, surahNumber: _selectedSurah!, ayahNumber: _selectedAyah!, showTafsir: false, settings: settings)),
           _toolbarAction(Icons.share_rounded, 'toolbar_copy'.tr(), () {
             Clipboard.setData(ClipboardData(text: quran.getVerse(_selectedSurah!, _selectedAyah!, verseEndSymbol: false)));
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('verse_copied_success'.tr())));
           }),
         ],
       ),
     );
   }

  Widget _toolbarAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: const Color(0xFF1D9E75), size: 20), Text(label, style: const TextStyle(color: Color(0xFF1D9E75), fontSize: 10, fontFamily: 'Cairo'))]));
  }

  Future<void> _playAyahAudio(int surahNum, int ayahNum) async {
    setState(() => _isAudioBuffering = true);
    try {
      final url = ref.read(reciterControllerProvider.notifier).buildAyahUrl(surahNum, ayahNum);
      await ref.read(audioControllerProvider.notifier).playAudio(url, surahName: SurahUtils.getLocalizedSurahName(context, surahNum), surahNumber: surahNum, ayahNumber: ayahNum);
    } catch (e) { print(e); } finally { if (mounted) setState(() => _isAudioBuffering = false); }
  }
}
