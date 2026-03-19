import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/hifz/presentation/controllers/hifz_home_controller.dart';
import 'package:sila_app/features/hifz/presentation/pages/methods/interactive_shadow_page.dart';
import 'package:sila_app/features/tasmi/presentation/pages/tasmi_surah_selection_page.dart' as import_tasmi;

const Color _hasanatGold = Color(0xFFFCD34D);
const Color _errorColor = Color(0xFFF87171);
const LinearGradient _headerGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF064E3B), Color(0xFF0A6B52), Color(0xFF1A3A5C)],
);
const LinearGradient _hasanatGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF1E3A5F), Color(0xFF2D5A8E)],
);

class HifzHomePage extends ConsumerStatefulWidget {
  const HifzHomePage({super.key});

  @override
  ConsumerState<HifzHomePage> createState() => _HifzHomePageState();
}

class _HifzHomePageState extends ConsumerState<HifzHomePage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      final c = ref.read(hifzHomeControllerProvider.notifier);
      c.loadTodayStats();
      c.loadRecentMoments();
      c.loadDueReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hifzHomeControllerProvider);
    final controller = ref.read(hifzHomeControllerProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(background: _Header(state: state)),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.errorMessage != null)
                      _ErrorCard(message: state.errorMessage!),
                    if (state.errorMessage != null) const SizedBox(height: 12),
                    _DailyPlanCard(state: state),
                    const SizedBox(height: 16),
                    // ==========================================
                    // TASMI3 MAIN HERO CARD (NEW PROMINENT LOCATION)
                    // ==========================================
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const import_tasmi.TasmiSurahSelectionPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF064E3B), Color(0xFF0a6b52)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF064E3B).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCD34D).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'الميزة الرئيسية ⭐',
                                      style: GoogleFonts.cairo(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFFCD34D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'التسميع بالذكاء الاصطناعي',
                                    style: GoogleFonts.cairo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'اختبر حفظك للقرآن الكريم مع مصحح آلي يستمع لتلاوتك ويصحح أخطائك بدقة',
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.mic_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _HasanatCard(hasanat: state.hasanatToday),
                    const SizedBox(height: 24),
                    Text(
                      'طرق الحفظ',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _MethodsGrid(
                      dueReviewCount: state.reviewDueCount,
                      onInteractiveShadow: () {
                        controller.startSession('interactive_shadow');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const InteractiveShadowPage()),
                        );
                      },
                      onSmartReview: controller.startReviewSession,
                      onListening: controller.startListeningSession,
                      onRepetition: controller.startRepetitionSession,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لحظاتي مع القرآن',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MomentsSection(moments: state.recentMoments),
                    if (state.activeSession != null) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.continueSession();
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const InteractiveShadowPage()),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                          label: Text(
                            'أكمل من حيث توقفت',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final HifzHomeState state;

  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: _headerGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Center(
                          child: Icon(Icons.notifications_none_rounded, color: Colors.white, size: 18),
                        ),
                        if (state.reviewDueCount > 0)
                          Positioned(
                            top: 3,
                            left: 3,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: _errorColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'أهلاً بك،',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        'حافظ القرآن',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '🔥 ${_toArabicIndic(state.streakDays)} يوم متواصل',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFCD34D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyPlanCard extends StatelessWidget {
  final HifzHomeState state;

  const _DailyPlanCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final total = state.targetAyahsToday <= 0 ? 1 : state.targetAyahsToday;
    final progress = (state.doneAyahsToday / total).clamp(0.0, 1.0);
    final now = DateTime.now();
    final todayArabicDate = '${_toArabicIndic(now.day)}/${_toArabicIndic(now.month)}/${_toArabicIndic(now.year)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'خطتك اليوم',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                todayArabicDate,
                style: GoogleFonts.cairo(
                  fontSize: 10,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (_, value, __) {
              return Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_toArabicIndic(state.doneAyahsToday)} / ${_toArabicIndic(total)} آيات',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آيات اليوم',
                style: GoogleFonts.cairo(
                  fontSize: 10,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'مراجعة: ${_toArabicIndic(state.reviewDueCount)} آيات',
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HasanatCard extends StatelessWidget {
  final int hasanat;

  const _HasanatCard({required this.hasanat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: _hasanatGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: hasanat),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (_, value, __) {
              return Text(
                _toArabicIndic(value),
                style: GoogleFonts.cairo(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: _hasanatGold,
                ),
              );
            },
          ),
          Text(
            'حسنة اكتسبتها اليوم بإذن الله',
            style: GoogleFonts.cairo(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'من قرأ حرفاً فله حسنة والحسنة بعشر أمثالها',
            style: GoogleFonts.cairo(
              fontSize: 9,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodsGrid extends StatelessWidget {
  final int dueReviewCount;
  final VoidCallback onInteractiveShadow;
  final VoidCallback onSmartReview;
  final VoidCallback onListening;
  final VoidCallback onRepetition;

  const _MethodsGrid({
    required this.dueReviewCount,
    required this.onInteractiveShadow,
    required this.onSmartReview,
    required this.onListening,
    required this.onRepetition,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        title: 'الظل التفاعلي',
        sub: 'استمع، ردد، ثم من الذاكرة',
        icon: '⭐',
        onTap: onInteractiveShadow,
        featured: true,
      ),
      (
        title: 'المراجعة الذكية',
        sub: '${_toArabicIndic(dueReviewCount)} آيات للمراجعة اليوم',
        icon: '🔄',
        onTap: onSmartReview,
        featured: false,
      ),
      (
        title: 'التلقي',
        sub: 'استمع مع الشيخ الحصري',
        icon: '🎧',
        onTap: onListening,
        featured: false,
      ),
      (
        title: 'التكرار',
        sub: 'احفظ بالتكرار المنتظم',
        icon: '📖',
        onTap: onRepetition,
        featured: false,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards.map((c) {
        return GestureDetector(
          onTap: c.onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.featured ? const Color(0xFFFFFBF0) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: c.featured ? AppTheme.accentColor : const Color(0xFFE2E8F0),
                width: c.featured ? 1.5 : 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (c.featured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '⭐ موصى به',
                      style: GoogleFonts.cairo(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(c.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  c.title,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  c.sub,
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MomentsSection extends StatelessWidget {
  final List<dynamic> moments;

  const _MomentsSection({required this.moments});

  @override
  Widget build(BuildContext context) {
    if (moments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF8FAFF), Color(0xFFF0F9FF)]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFBFDBFE), width: 0.5),
        ),
        child: Column(
          children: [
            const Text('💎', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              'لم تسجّل لحظة بعد',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E40AF),
              ),
            ),
            Text(
              'ستجد هنا الآيات التي لمست قلبك',
              style: GoogleFonts.cairo(
                fontSize: 10,
                color: const Color(0xFF93C5FD),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 90,
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: moments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final moment = moments[index];
          final surahName = quran.getSurahNameArabic(moment.surahIndex);
          return Container(
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('💎', style: TextStyle(fontSize: 14)),
                Text(
                  surahName,
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  moment.reflection,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _errorColor.withValues(alpha: 0.08),
        border: Border.all(color: _errorColor.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: GoogleFonts.cairo(fontSize: 11, color: _errorColor),
      ),
    );
  }
}

String _toArabicIndic(int value) {
  final western = value.toString();
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final buffer = StringBuffer();
  for (final unit in western.codeUnits) {
    final digit = unit - 48;
    if (digit >= 0 && digit <= 9) {
      buffer.write(digits[digit]);
    }
  }
  return buffer.toString();
}
