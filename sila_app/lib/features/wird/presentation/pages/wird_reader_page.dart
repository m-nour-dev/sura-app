import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/features/wird/presentation/riverpod/wird_controller.dart';
import 'package:sila_app/features/wird/data/models/wird_settings.dart';

class WirdReaderPage extends ConsumerStatefulWidget {
  final int startPage;
  final int endPage; // Optional visual indicator, user can read beyond

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
    // PageController uses 0-based index logically, but quran pages are 1-604
    // We will map index 0 -> page 1. So index = page - 1
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
    // Save current page
    ref.read(wirdControllerProvider.notifier).updateCurrentPage(newPage);
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _currentPage >= widget.endPage;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Cream background like Quran pages
      appBar: AppBar(
        title: Text('${'page'.tr()} $_currentPage'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF8E1),
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          // Completion Button (Visible if reached target)
          if (isDone)
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                 // Show completion dialog (same as in Home)
                 Navigator.pop(context, true); // Return true to indicate completion desire
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                reverse: true, // Quran reads Right-to-Left, so reverse PageView logic
                itemCount: WirdSettings.totalQuranPages,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final pageNum = index + 1;
                  return _buildQuranPage(pageNum);
                },
              ),
            ),
            // Footer Info
            Container(
               padding: const EdgeInsets.symmetric(vertical: 8),
               color: Colors.brown.withOpacity(0.05),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                    Text(
                      '${'juz'.tr()} ${quran.getJuzNumber(_currentPage, 1)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Text(quran.getSurahNameArabic(quran.getPageData(_currentPage)[0]['surah'])),
                 ],
               ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranPage(int pageNumber) {
    // Get Ayahs for this page
    // quran.getPageData returns list of maps: {surah: X, start: Y, end: Z}
    final pageData = quran.getPageData(pageNumber);
    
    // We need to build the full text of the page.
    // This is a simplified text view. For real app, ideally use images or custom font rendering.
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
             // Page Content
             // Iterate over surahs in this page
             for (var data in pageData) ...[
                _buildSurahSegment(data['surah'], data['start'], data['end']),
             ]
        ],
      ),
    );
  }

  Widget _buildSurahSegment(int surahNum, int startAyah, int endAyah) {
    String versesText = "";
    for (int i = startAyah; i <= endAyah; i++) {
      versesText += "${quran.getVerse(surahNum, i)} ﴿$i﴾ ";
    }
    
    return Column(
      children: [
        if (startAyah == 1) ...[ // Start of Surah?
           const SizedBox(height: 10),
           Container(
             width: double.infinity,
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               border: Border.all(color: Colors.brown),
               color: const Color(0xFFEFEBE9),
             ),
             child: Text(
               "سورة ${quran.getSurahNameArabic(surahNum)}",
               textAlign: TextAlign.center,
               style: const TextStyle(fontFamily: 'Uthmanic', fontSize: 18, fontWeight: FontWeight.bold),
             ),
           ),
           if (surahNum != 1 && surahNum != 9) // Fatiha and Tawbah handling for Basmala
             const Padding(
               padding: EdgeInsets.symmetric(vertical: 8.0),
               child: Text("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", style: TextStyle(fontFamily: 'Uthmanic', fontSize: 16)),
             ), 
        ],
        
        Text(
          versesText,
          textAlign: TextAlign.justify,
          textDirection: ui.TextDirection.rtl,
          style: const TextStyle(
            fontFamily: 'Uthmanic', // Ideally use a font like UthmanicHafs
            fontSize: 20,
            height: 1.8,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
