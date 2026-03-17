import 'dart:convert';
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
        final currentSurah = surahData.isNotEmpty ? surahData[0]['surah'] as int : 1;
        final firstAyah = surahData.isNotEmpty ? surahData[0]['start'] as int : 1;
        final currentJuz = quran.getJuzNumber(currentSurah, firstAyah);
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
    List<TextSpan> allSpans = [];
    List<Map<String, dynamic>> ayahPositions = [];
    int currentLength = 0;
    
    for (int i = startAyah; i <= endAyah; i++) {
      final key = '${surahNum}_$i';
      
      // Fallback to plain quran data if Tajweed fails or isn't loaded
      String rawVerse = (_isQuranDataLoaded && _tajweedData.containsKey(key)) 
          ? _tajweedData[key] 
          : quran.getVerse(surahNum, i);
          
      // Ensure we add the ayah number and a space
      rawVerse = "$rawVerse ﴿${_arabicNumber(i)}﴾ ";
      
      // Parse spans and calculate true plain text length
      final spansResult = _buildTajweedSpans(rawVerse, settings);
      final spans = spansResult['spans'] as List<TextSpan>;
      final plainLength = spansResult['length'] as int;
      
      ayahPositions.add({
        'ayahNum': i,
        'start': currentLength,
        'end': currentLength + plainLength,
      });
      
      currentLength += plainLength;
      allSpans.addAll(spans);
    }
    
    return Column(
      children: [
        if (startAyah == 1) ...[ 
           _buildBismillahFrame(surahNum, settings),
           if (surahNum != 1 && surahNum != 9) 
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 16.0),
               child: Text(
                 "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", 
                 style: TextStyle(fontFamily: 'Amiri', fontSize: 24, color: _getTextColor(settings.themeMode)),
               ),
             ), 
        ],
        
        _buildSelectableVerse(surahNum, startAyah, endAyah, allSpans, ayahPositions, settings),
        const SizedBox(height: 16),
      ],
    );
  }

  Map<String, dynamic> _buildTajweedSpans(String text, QuranSettings settings) {
    List<TextSpan> spans = [];
    int plainLength = 0;
    
    // Pattern to match [ruleCode[content]
    final RegExp exp = RegExp(r'\[([a-zA-Z0-9:]+)\[([^\]]+)\]');
    int lastIndex = 0;
    
    for (final Match m in exp.allMatches(text)) {
      if (m.start > lastIndex) {
        final substring = text.substring(lastIndex, m.start);
        spans.add(TextSpan(text: substring));
        plainLength += substring.length;
      }
      
      String rule = m.group(1)!;
      String tajweedText = m.group(2)!;
      Color textColor = _getTajweedColor(rule, settings);
      
      spans.add(TextSpan(
        text: tajweedText,
        style: TextStyle(color: textColor),
      ));
      plainLength += tajweedText.length;
      
      lastIndex = m.end;
    }
    
    if (lastIndex < text.length) {
      final substring = text.substring(lastIndex);
      spans.add(TextSpan(text: substring));
      plainLength += substring.length;
    }
    
    return {'spans': spans, 'length': plainLength};
  }

  Color _getTajweedColor(String rule, QuranSettings settings) {
    final baseColor = _getTextColor(settings.themeMode);
    final isDark = settings.themeMode == QuranThemeMode.dark;
    
    if (rule.startsWith('h') || rule.startsWith('s') || rule.startsWith('l') || rule.startsWith('w')) {
      return isDark ? Colors.grey[600]! : Colors.grey[400]!;
    } else if (rule.startsWith('g') || rule.startsWith('f')) {
      return Colors.green;
    } else if (rule.startsWith('m')) {
      return Colors.red;
    } else if (rule.startsWith('o')) {
      return Colors.red[900]!;
    } else if (rule.startsWith('q')) {
      return Colors.blue;
    } else if (rule.startsWith('c')) {
      return Colors.purple;
    } else if (rule.startsWith('p')) {
      return Colors.green[700]!;
    } else if (rule.startsWith('i')) {
      return Colors.cyan;
    }
    return baseColor;
  }

  Widget _buildSelectableVerse(int surahNum, int startAyah, int endAyah, List<TextSpan> spans, List<Map<String, dynamic>> ayahPositions, QuranSettings settings) {
    return SelectableText.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.justify,
      textDirection: ui.TextDirection.rtl,
      style: GoogleFonts.getFont(
        settings.fontFamily,
        fontSize: settings.fontSize,
        height: 2.2,
        color: _getTextColor(settings.themeMode),
      ),
      contextMenuBuilder: (context, editableTextState) {
        final List<ContextMenuButtonItem> buttonItems = [
          ...editableTextState.contextMenuButtonItems,
          ContextMenuButtonItem(
            label: '📖 تفسير',
            onPressed: () {
              ContextMenuController.removeAny();
              
              final selection = editableTextState.textEditingValue.selection;
              int selectedAyahNum = startAyah;
              
              if (selection.isValid) {
                 final selStart = selection.start;
                 for (var pos in ayahPositions) {
                    if (selStart >= pos['start'] && selStart < pos['end']) {
                       selectedAyahNum = pos['ayahNum'];
                       break;
                    }
                 }
              }
              
              _showTafsirSheet(context, surahNum, selectedAyahNum, selectedAyahNum, settings);
            },
          ),
        ];
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
    );
  }

  void _showTafsirSheet(BuildContext context, int surahNum, int startAyah, int endAyah, QuranSettings settings) {
    final tafsir = _getTafsir(surahNum, startAyah, endAyah);
    final surahName = quran.getSurahNameArabic(surahNum);
    final isDark = settings.themeMode == QuranThemeMode.dark;
    
    // For single verse selection, display the verse text itself prominently
    final verseText = startAyah == endAyah ? quran.getVerse(surahNum, startAyah) : "";
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparent for Glassmorphism
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5), // Darker barrier for focus
      builder: (context) => BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16), // Stronger blur
        child: DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: _getBackgroundColor(settings.themeMode).withOpacity(isDark ? 0.85 : 0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              boxShadow: [
                 BoxShadow(
                   color: _getAccentColor(settings.themeMode).withOpacity(0.15),
                   blurRadius: 30,
                   spreadRadius: 5,
                 )
              ],
              border: Border.all(
                color: _getAccentColor(settings.themeMode).withOpacity(isDark ? 0.2 : 0.4),
                width: 1.0,
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                               gradient: LinearGradient(
                                 colors: [
                                    _getAccentColor(settings.themeMode),
                                    _getAccentColor(settings.themeMode).withOpacity(0.7)
                                 ],
                                 begin: Alignment.topLeft,
                                 end: Alignment.bottomRight,
                               ),
                               shape: BoxShape.circle,
                               boxShadow: [
                                 BoxShadow(
                                   color: _getAccentColor(settings.themeMode).withOpacity(0.4),
                                   blurRadius: 10, offset: const Offset(0, 4)
                                 )
                               ]
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'التفسير الميسّر',
                                style: GoogleFonts.cairo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _getTextColor(settings.themeMode),
                                ),
                              ),
                              Text(
                                'سورة $surahName - آية $startAyah',
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _getAccentColor(settings.themeMode),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: Colors.grey[500], size: 28),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Quranic Verse Quote Block
                  if (verseText.isNotEmpty) ...[
                     Container(
                       padding: const EdgeInsets.all(24),
                       decoration: BoxDecoration(
                         color: _getAccentColor(settings.themeMode).withOpacity(0.05),
                         borderRadius: BorderRadius.circular(24),
                         border: Border.all(color: _getAccentColor(settings.themeMode).withOpacity(0.15)),
                       ),
                       child: Column(
                         children: [
                           Icon(Icons.format_quote_rounded, color: _getAccentColor(settings.themeMode).withOpacity(0.5), size: 32),
                           const SizedBox(height: 8),
                           Text(
                             "﴿ $verseText ﴾",
                             textAlign: TextAlign.center,
                             textDirection: ui.TextDirection.rtl,
                             style: TextStyle(
                               fontFamily: 'Amiri',
                               fontSize: 24,
                               height: 2.0,
                               fontWeight: FontWeight.bold,
                               color: _getTextColor(settings.themeMode),
                             ),
                           ),
                         ],
                       ),
                     ),
                     const SizedBox(height: 32),
                  ],
                  
                  // Tafsir Text
                  Text(
                    "التفسير:",
                    textAlign: TextAlign.right,
                    textDirection: ui.TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _getAccentColor(settings.themeMode),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tafsir.replaceAll('\n', '\n\n'), // Ensure paragraph breaks
                    textAlign: TextAlign.justify,
                    textDirection: ui.TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: settings.fontFamily, // Match reader font
                      fontSize: settings.fontSize * 0.9, // Slightly smaller than Quran text
                      height: 2.2,
                      color: _getTextColor(settings.themeMode).withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getAccentColor(settings.themeMode),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 4,
                      shadowColor: _getAccentColor(settings.themeMode).withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('إغلاق', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _tafsirData = {};
  Map<String, dynamic> _tajweedData = {};
  bool _isQuranDataLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isQuranDataLoaded) {
      _loadQuranData();
    }
  }

  Future<void> _loadQuranData() async {
    try {
      final String tafsirStr = await DefaultAssetBundle.of(context).loadString('assets/data/tafseer.json');
      final String tajweedStr = await DefaultAssetBundle.of(context).loadString('assets/data/tajweed.json');
      setState(() {
        _tafsirData = Map<String, dynamic>.from(jsonDecode(tafsirStr));
        _tajweedData = Map<String, dynamic>.from(jsonDecode(tajweedStr));
        _isQuranDataLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading quran data: $e');
      setState(() => _isQuranDataLoaded = true); // Proceed anyway to show plain text
    }
  }

  String _getTafsir(int surahNum, int startAyah, int endAyah) {
    if (!_isQuranDataLoaded || _tafsirData.isEmpty) {
      return 'جاري تحميل التفسير...';
    }
    
    // In many Tafsir JSONs, keys are exactly "Surah_Ayah" (e.g., "1_1")
    String fullTafsir = '';
    for(int i = startAyah; i <= endAyah; i++) {
       final key = '${surahNum}_$i';
       final text = _tafsirData[key];
       if (text != null) {
          fullTafsir += '$text\\n\\n';
       }
    }
    
    if (fullTafsir.trim().isEmpty) {
       return 'للأسف، التفسير لهذه الآيات غير متوفر في النسخة الحالية.';
    }
    
    return fullTafsir.trim();
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
