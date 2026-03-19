import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/quran/presentation/pages/surah_detail_page.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_controller.dart';

class QuranPage extends ConsumerStatefulWidget {
  const QuranPage({super.key});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final quranState = ref.watch(quranControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFDFBF7);
    final surface = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? Colors.white12 : const Color(0xFFE2E8F0);
    final txtP = isDark ? Colors.white : const Color(0xFF0F172A);
    final txtS = isDark ? Colors.white60 : const Color(0xFF64748B);
    const primaryColor = Color(0xFF064E3B);

    return Scaffold(
      backgroundColor: bg,
      body: quranState.when(
        data: (surahs) {
          final filteredSurahs = surahs.where((s) {
            if (_searchQuery.isEmpty) return true;
            return s.nameArabic.contains(_searchQuery) ||
                   s.englishName.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return CustomScrollView(
            slivers: [
              // ── Header ──
              SliverAppBar(
                pinned: true,
                backgroundColor: primaryColor,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF064E3B), Color(0xFF0a6b52), Color(0xFF1a3a5c)],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'القرآن الكريم',
                              style: GoogleFonts.getFont(
                                'Cairo',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${surahs.length} سورة',
                              style: GoogleFonts.getFont(
                                'Cairo',
                                fontSize: 13,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.getFont('Cairo', color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن سورة...',
                        hintStyle: GoogleFonts.getFont('Cairo', color: Colors.white60, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Colors.white60, size: 20),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Surah List ──
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final surah = filteredSurahs[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SurahDetailPage(
                                surahNumber: surah.number,
                                surahName: context.locale.languageCode == 'ar'
                                    ? surah.nameArabic
                                    : surah.nameTurkish,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: border, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              // رقم السورة — دائرة
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${surah.number}',
                                    style: GoogleFonts.getFont(
                                      'Cairo',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // اسم السورة
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah.nameArabic,
                                      style: GoogleFonts.getFont(
                                        'Amiri',
                                        fontSize: 17,
                                        color: txtP,
                                      ),
                                    ),
                                    Text(
                                      '${surah.numberOfAyahs} آية · ${surah.revelationType}',
                                      style: GoogleFonts.getFont(
                                        'Cairo',
                                        fontSize: 11,
                                        color: txtS,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // اسم السورة بالخط الكبير (يمين)
                              Text(
                                surah.nameArabic,
                                style: GoogleFonts.getFont(
                                  'Amiri',
                                  fontSize: 20,
                                  color: primaryColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredSurahs.length,
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error', style: TextStyle(color: txtP)),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      ),
    );
  }
}
