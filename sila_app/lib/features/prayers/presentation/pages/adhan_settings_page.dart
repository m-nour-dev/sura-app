import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/services/adhan_scheduler_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';

class AdhanSettingsPage extends ConsumerStatefulWidget {
  const AdhanSettingsPage({super.key});
  @override
  ConsumerState<AdhanSettingsPage> createState() => _AdhanSettingsPageState();
}

class _AdhanSettingsPageState extends ConsumerState<AdhanSettingsPage> {
  final _prefs = PrefsService();
  final _adhanSvc = AdhanSchedulerService();

  bool _adhanEnabled = true;
  String _selectedSound = 'adhan_egypt.mp3';
  Map<String, bool> _prayerSettings = {
    'fajr': true, 'dhuhr': true, 'asr': true, 'maghrib': true, 'isha': true,
  };

  static const _sounds = {
    'adhan_egypt.mp3': 'أذان مصر',
    'https://www.islamcan.com/audio/adhan/azan1.mp3': 'أذان الحرم المكي (مباشر)',
    'https://www.islamcan.com/audio/adhan/azan2.mp3': 'أذان المدينة النبوية (مباشر)',
    'https://www.islamcan.com/audio/adhan/azan3.mp3': 'أذان الشيخ مشاري العفاسي (مباشر)',
    'https://www.islamcan.com/audio/adhan/azan4.mp3': 'أذان الشيخ علي ملا (مباشر)',
    'https://www.islamcan.com/audio/adhan/azan5.mp3': 'أذان مؤثر كلاسيكي (مباشر)',
  };

  static const _prayerList = [
    {'key': 'fajr',    'name': 'الفجر',   'icon': Icons.wb_twilight_rounded},
    {'key': 'dhuhr',   'name': 'الظهر',   'icon': Icons.wb_sunny_rounded},
    {'key': 'asr',     'name': 'العصر',   'icon': Icons.wb_sunny_outlined},
    {'key': 'maghrib', 'name': 'المغرب',  'icon': Icons.wb_incandescent_rounded},
    {'key': 'isha',    'name': 'العشاء',  'icon': Icons.nightlight_round},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _prefs.isAdhanNotificationsEnabled();
    final sound = await _prefs.getAdhanSound();
    final Map<String, bool> settings = {};
    for (final p in _prayerList) {
      settings[p['key'] as String] =
          await _prefs.isAdhanEnabled(p['key'] as String);
    }
    if (mounted) {
      setState(() {
        _adhanEnabled = enabled;
        _selectedSound = sound;
        _prayerSettings = settings;
      });
    }
  }

  Future<void> _toggleGlobal(bool v) async {
    await _prefs.setAdhanNotificationsEnabled(v);
    setState(() => _adhanEnabled = v);
    if (!v) await _adhanSvc.cancelAllPrayers();
    _snack(v ? 'تم تفعيل الأذان' : 'تم تعطيل الأذان');
  }

  Future<void> _togglePrayer(String key, bool v) async {
    await _prefs.setAdhanEnabled(key, v);
    setState(() => _prayerSettings[key] = v);
    ref.invalidate(prayerTimesControllerProvider);
    _snack(v ? 'تم تفعيل أذان ${_arabicName(key)}' : 'تم تعطيل أذان ${_arabicName(key)}');
  }

  Future<void> _changeSound(String f) async {
    await _prefs.setAdhanSound(f);
    setState(() => _selectedSound = f);
    _snack('تم تغيير صوت الأذان');
  }

  Future<void> _testAdhan() async {
    await _adhanSvc.testAdhan(_selectedSound);
    _snack('جاري تشغيل الأذان... أوقفه من زر "إيقاف الأذان" في الإشعار');
  }

  void _snack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg, style: GoogleFonts.cairo()),
            duration: const Duration(seconds: 2)),
      );
    }
  }

  String _arabicName(String key) {
    final match = _prayerList.firstWhere(
        (p) => p['key'] == key, orElse: () => {'name': key});
    return match['name'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1E),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('إعدادات الأذان',
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Global toggle ────────────────────────────────────────────────
          _card(
            child: SwitchListTile(
              title: Text('تفعيل الأذان',
                  style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              subtitle: Text('تفعيل جميع إشعارات الأذان',
                  style: GoogleFonts.cairo(color: Colors.white38, fontSize: 12)),
              value: _adhanEnabled,
              onChanged: _toggleGlobal,
              activeColor: const Color(0xFF43A047),
            ),
          ),

          const SizedBox(height: 16),

          // ── Sound selector ───────────────────────────────────────────────
          _card(
            child: ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.volume_up_rounded,
                    color: Color(0xFF66BB6A), size: 20),
              ),
              title: Text('صوت الأذان',
                  style: GoogleFonts.cairo(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text(_sounds[_selectedSound] ?? _selectedSound,
                  style: GoogleFonts.cairo(color: Colors.white38, fontSize: 12)),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: Colors.white38),
              onTap: _showSoundDialog,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.22)),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_rounded, color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الأصوات المكتوب بجانبها (مباشر) تحتاج اتصال إنترنت.\nعند فشلها يتم تشغيل أذان مصر تلقائياً.',
                    style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Per-prayer ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('تفعيل الأذان لكل صلاة',
                style: GoogleFonts.cairo(
                    color: const Color(0xFF43A047),
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),

          _card(
            child: Column(
              children: _prayerList.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                final key = p['key'] as String;
                final isEnabled = _prayerSettings[key] ?? true;
                return Column(
                  children: [
                    SwitchListTile(
                      secondary: Icon(p['icon'] as IconData,
                          color: _adhanEnabled && isEnabled
                              ? const Color(0xFF66BB6A)
                              : Colors.white24,
                          size: 22),
                      title: Text(p['name'] as String,
                          style: GoogleFonts.cairo(
                              color: _adhanEnabled ? Colors.white : Colors.white30,
                              fontSize: 15)),
                      value: isEnabled && _adhanEnabled,
                      onChanged: _adhanEnabled
                          ? (v) => _togglePrayer(key, v)
                          : null,
                      activeColor: const Color(0xFF43A047),
                    ),
                    if (i < _prayerList.length - 1)
                      Divider(color: Colors.white.withOpacity(0.06), height: 1,
                          indent: 16, endIndent: 16),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // ── Test button ──────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _testAdhan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: Text('اختبار صوت الأذان',
                  style: GoogleFonts.cairo(fontSize: 15)),
            ),
          ),

          const SizedBox(height: 16),

          // ── Info ─────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Colors.blueAccent, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'سيتم تشغيل الأذان تلقائياً في أوقات الصلاة حتى لو كان التطبيق مغلقاً',
                    style: GoogleFonts.cairo(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: child,
    );
  }

  void _showSoundDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('اختر صوت الأذان',
                  style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            ..._sounds.entries.map((e) => RadioListTile<String>(
                  value: e.key,
                  groupValue: _selectedSound,
                  title: Text(e.value,
                      style: GoogleFonts.cairo(color: Colors.white70)),
                  activeColor: const Color(0xFF43A047),
                  onChanged: (v) {
                    if (v != null) {
                      _changeSound(v);
                      Navigator.pop(context);
                    }
                  },
                )),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء',
                  style: GoogleFonts.cairo(color: Colors.white38)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
