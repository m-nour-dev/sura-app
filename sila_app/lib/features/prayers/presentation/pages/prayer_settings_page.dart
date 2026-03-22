import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/presentation/widgets/audio_storage_sheet.dart';
import 'package:sila_app/core/presentation/widgets/reciter_picker_sheet.dart';
import 'package:sila_app/core/providers/reciter_provider.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/tasmi/presentation/pages/tasmi_onboarding_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/adhan_settings_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:sila_app/features/prayers/presentation/widgets/location_settings_dialog.dart';

// ── All supported calculation methods ────────────────────────────────────────
const _methods = {
  'turkey':              'رئاسة الشؤون الدينية – تركيا',
  'muslim_world_league': 'رابطة العالم الإسلامي',
  'egyptian':            'الهيئة المصرية العامة للمساحة',
  'umm_al_qura':         'جامعة أم القرى – مكة المكرمة',
  'morocco':             'وزارة الأوقاف المغربية',
  'indonesia':           'وزارة الشؤون الدينية – إندونيسيا',
  'karachi':             'جامعة العلوم الإسلامية – كراتشي',
  'north_america':       'ISNA – أمريكا الشمالية',
  'dubai':               'الإمارات',
  'qatar':               'قطر',
  'kuwait':              'الكويت',
  'singapore':           'سنغافورة',
};

class PrayerSettingsPage extends ConsumerStatefulWidget {
  const PrayerSettingsPage({super.key});

  @override
  ConsumerState<PrayerSettingsPage> createState() => _PrayerSettingsPageState();
}

class _PrayerSettingsPageState extends ConsumerState<PrayerSettingsPage> {
  final _prefs = PrefsService();
  String _method = 'turkey';
  bool _isAuto = true;
  String _cityName = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final method = await _prefs.getCalculationMethod();
    final isAuto = await _prefs.isAutoLocation();
    final stored = await _prefs.getStoredLocation();
    setState(() {
      _method = method;
      _isAuto = isAuto;
      _cityName = stored?['city'] as String? ?? '';
    });
  }

  Future<void> _pickMethod() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => _MethodDialog(current: _method),
    );
    if (selected != null && selected != _method) {
      await _prefs.setCalculationMethod(selected);
      setState(() => _method = selected);
      ref.invalidate(prayerTimesControllerProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث طريقة الحساب')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentReciter = ref.watch(reciterControllerProvider).valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1E),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'إعدادات المواقيت',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(label: 'الموقع', children: [
            _Tile(
              icon: Icons.location_on_rounded,
              title: 'تحديد الموقع تلقائياً',
              subtitle: _isAuto ? 'مفعّل – GPS' : 'معطّل',
              trailing: Switch(
                value: _isAuto,
                activeColor: const Color(0xFF43A047),
                onChanged: (v) async {
                  await _prefs.setAutoLocation(v);
                  setState(() => _isAuto = v);
                  ref.invalidate(prayerTimesControllerProvider);
                },
              ),
            ),
            if (!_isAuto)
              _Tile(
                icon: Icons.edit_location_alt_rounded,
                title: 'تغيير المدينة',
                subtitle:
                    _cityName.isNotEmpty ? _cityName : 'اضغط لتحديد المدينة',
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const LocationSettingsDialog(),
                  );
                  await _load();
                  ref.invalidate(prayerTimesControllerProvider);
                },
              ),
          ]),

          const SizedBox(height: 16),

          _Section(label: 'طريقة الحساب', children: [
            _Tile(
              icon: Icons.calculate_rounded,
              title: 'الطريقة المستخدمة',
              subtitle: _methods[_method] ?? _method,
              onTap: _pickMethod,
              trailing:
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38),
            ),
            if (_isAuto)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'ℹ️  يتم اختيار طريقة الحساب تلقائياً بناءً على دولتك',
                  style: GoogleFonts.cairo(
                      color: Colors.white38, fontSize: 12),
                ),
              ),
          ]),

          const SizedBox(height: 16),

          _Section(label: 'أذان وإشعارات', children: [
            _Tile(
              icon: Icons.notifications_active_rounded,
              title: 'إعدادات الأذان',
              subtitle: 'صوت الأذان وإشعارات كل صلاة',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdhanSettingsPage())),
              trailing:
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38),
            ),
          ]),

          const SizedBox(height: 16),

          _Section(label: 'القبلة', children: [
            _Tile(
              icon: Icons.explore_rounded,
              title: 'اتجاه القبلة',
              subtitle: 'بوصلة القبلة التفاعلية',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const QiblahPage())),
              trailing:
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38),
            ),
          ]),

          const SizedBox(height: 16),

          _Section(label: 'التسميع', children: [
            _Tile(
              icon: Icons.tune_rounded,
              title: 'إعدادات التسميع',
              subtitle: 'غيّر تفضيلاتك للتسميع',
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white38),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TasmiOnboardingPage(
                    onDone: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            _Tile(
              icon: Icons.mic_rounded,
              title: 'الشيخ المختار',
              subtitle: currentReciter?.nameArabic ?? 'الشيخ محمود خليل الحصري',
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white38),
              onTap: () => showReciterPickerSheet(context),
            ),
            _Tile(
              icon: Icons.storage_rounded,
              title: 'إدارة مساحة الصوت',
              subtitle: 'عرض وحذف كاش التلاوات',
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white38),
              onTap: () => showAudioStorageSheet(context),
            ),
          ]),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const _Section({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.cairo(
              color: const Color(0xFF43A047),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF43A047).withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF66BB6A), size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.cairo(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle,
          style: GoogleFonts.cairo(color: Colors.white38, fontSize: 12)),
      trailing: trailing,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// ── Method picker dialog ───────────────────────────────────────────────────

class _MethodDialog extends StatelessWidget {
  final String current;
  const _MethodDialog({required this.current});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0D1B2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'اختر طريقة الحساب',
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 380,
            child: ListView(
              children: _methods.entries.map((e) {
                final selected = e.key == current;
                return ListTile(
                  onTap: () => Navigator.pop(context, e.key),
                  title: Text(e.value,
                      style: GoogleFonts.cairo(
                          color: selected
                              ? const Color(0xFF66BB6A)
                              : Colors.white70,
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400)),
                  trailing: selected
                      ? const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF43A047))
                      : null,
                );
              }).toList(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء',
                style: GoogleFonts.cairo(color: Colors.white54)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
