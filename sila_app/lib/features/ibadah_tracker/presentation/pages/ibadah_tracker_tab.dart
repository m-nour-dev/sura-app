import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sila_app/features/ibadah_tracker/domain/daily_status_calculator.dart';
import 'package:sila_app/features/ibadah_tracker/presentation/controllers/ibadah_tracker_controller.dart';
import 'package:sila_app/features/ibadah_tracker/presentation/pages/daily_report_page.dart';
import 'package:sila_app/features/ibadah_tracker/presentation/pages/ibadah_detail_sheet.dart';

class IbadahTrackerTab extends ConsumerStatefulWidget {
  const IbadahTrackerTab({super.key});

  @override
  ConsumerState<IbadahTrackerTab> createState() => _IbadahTrackerTabState();
}

class _IbadahTrackerTabState extends ConsumerState<IbadahTrackerTab> {
  bool _dialogShown = false;

  String _hijriArabicDate() {
    final h = HijriCalendar.now();
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];
    final month = months[(h.hMonth - 1).clamp(0, 11)];
    return '${h.hDay} $month ${h.hYear}هـ';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ibadahTrackerControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFDFBF7);

    state.whenData((value) {
      if (!_dialogShown && value.onboardingNeeded) {
        _dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showGenderDialog(context);
        });
      }
    });

    return Scaffold(
      backgroundColor: bg,
      body: state.when(
        data: (data) {
          final hijriDate = _hijriArabicDate();
          final dayName = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'][DateTime.now().weekday - 1];
          final dailyStatusText = DailyStatusCalculator.getDailyStatusText(
            data.today,
            isMale: data.isMale,
          );
          final completionRatio = data.completionRatio;

          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedHeaderDelegate(
                  minHeight: 198,
                  maxHeight: 198,
                  child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF064E3B), Color(0xFF0a6b52)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hijriDate,
                          style: GoogleFonts.getFont('Cairo', fontSize: 12, color: Colors.white60),
                        ),
                        Text(
                          dayName,
                          style: GoogleFonts.getFont('Cairo', fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dailyStatusText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont('Amiri', fontSize: 16, color: Colors.white, height: 1.8),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: completionRatio,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFD97706)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${data.completedCount} من ${data.totalCount} عبادة',
                      style: GoogleFonts.getFont('Cairo', fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
                  ),
                  child: Column(
                    children: [
                      _tableHeader(isDark, showYesterday: data.yesterday != null),
                      _row('fajr', '🕌', 'الفجر', data),
                      _row('dhuhr', '🕌', 'الظهر', data),
                      _row('asr', '🕌', 'العصر', data),
                      _row('maghrib', '🕌', 'المغرب', data),
                      _row('isha', '🕌', 'العشاء', data),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      _row('wird', '📖', 'الورد', data),
                      _row('azkar_sabah', '🌅', 'أذكار الصباح', data),
                      _row('azkar_masa', '🌆', 'أذكار المساء', data),
                      _row('hifz', '📚', 'الحفظ / التسميع', data),
                      _row('tasbih', '💎', 'التسبيح', data),
                      _row('dhikr', '🔵', 'ذكر الله', data),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF064E3B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DailyReportPage()),
                    ),
                    child: Text(
                      'تقريري اليومي',
                      style: GoogleFonts.getFont('Cairo', color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('تعذر تحميل المتابعة')),
      ),
    );
  }

  Widget _tableHeader(bool isDark, {required bool showYesterday}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF9F5EC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: showYesterday ? 3 : 4,
            child: Text('العبادة', style: GoogleFonts.getFont('Cairo', fontSize: 12, color: Colors.grey[500])),
          ),
          if (showYesterday)
            Expanded(
              child: Text(
                'أمس',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont('Cairo', fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          Expanded(
            child: Text(
              'اليوم',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF064E3B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String key, String icon, String label, IbadahTrackerState s) {
    final showYesterday = s.yesterday != null;
    final ys = s.yesterday == null ? null : _status(s.yesterday, key);
    final ts = _status(s.today, key);

    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => showIbadahDetailSheet(
          context: context,
          ref: ref,
          ibadahKey: key,
          label: label,
          icon: icon,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: showYesterday ? 3 : 4,
                child: Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(label, style: GoogleFonts.getFont('Cairo', fontSize: 13)),
                  ],
                ),
              ),
              if (showYesterday)
                Expanded(
                  child: Center(
                    child: Text(
                      _emoji(ys),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _color(ts).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_emoji(ts), style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _status(r, String key) {
    switch (key) {
      case 'fajr':
        return r.fajrStatus;
      case 'dhuhr':
        return r.dhuhrStatus;
      case 'asr':
        return r.asrStatus;
      case 'maghrib':
        return r.maghribStatus;
      case 'isha':
        return r.ishaStatus;
      case 'wird':
        return r.readWird;
      case 'azkar_sabah':
        return r.readAzkarSabah;
      case 'azkar_masa':
        return r.readAzkarMasa;
      case 'hifz':
        return r.didHifz || r.didTasmi;
      case 'tasbih':
        return r.didTasbih;
      case 'dhikr':
        return r.rememberedAllah;
      default:
        return null;
    }
  }

  String _emoji(status) {
    if (status == null) return '⏳';
    if (status is int) {
      switch (status) {
        case 0:
          return '❌';
        case 1:
          return '✅';
        case 2:
          return '🕐';
      }
      return '⏳';
    }
    return status == true ? '✅' : '❌';
  }

  Color _color(status) {
    if (status == null) return Colors.grey;
    if (status is int) {
      if (status == 1) return const Color(0xFF064E3B);
      if (status == 2) return const Color(0xFFD97706);
      return Colors.red;
    }
    return status == true ? const Color(0xFF064E3B) : Colors.red;
  }

  Future<void> _showGenderDialog(BuildContext context) async {
    final controller = ref.read(ibadahTrackerControllerProvider.notifier);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'بسم الله',
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF064E3B),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'حتى نعرض لك ما يناسبك',
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont('Cairo', fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _GenderCard(
                    label: 'أخ',
                    icon: '🧔',
                    onTap: () async {
                      await controller.setGender(isMale: true);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderCard(
                    label: 'أخت',
                    icon: '🧕',
                    onTap: () async {
                      await controller.setGender(isMale: false);
                      if (context.mounted) Navigator.pop(context);
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
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate({required this.minHeight, required this.maxHeight, required this.child});

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({required this.label, required this.icon, required this.onTap});
  final String label;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.getFont('Cairo', fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
