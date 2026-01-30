import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/core/services/adhan_scheduler_service.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';

class AdhanSettingsPage extends ConsumerStatefulWidget {
  const AdhanSettingsPage({super.key});

  @override
  ConsumerState<AdhanSettingsPage> createState() => _AdhanSettingsPageState();
}

class _AdhanSettingsPageState extends ConsumerState<AdhanSettingsPage> {
  final PrefsService _prefsService = PrefsService();
  final AdhanSchedulerService _adhanService = AdhanSchedulerService();

  bool _adhanEnabled = true;
  String _selectedSound = 'adhan_mecca.mp3';
  
  Map<String, bool> _prayerSettings = {
    'fajr': true,
    'dhuhr': true,
    'asr': true,
    'maghrib': true,
    'isha': true,
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final adhanEnabled = await _prefsService.isAdhanNotificationsEnabled();
    final adhanSound = await _prefsService.getAdhanSound();

    final fajrEnabled = await _prefsService.isAdhanEnabled('fajr');
    final dhuhrEnabled = await _prefsService.isAdhanEnabled('dhuhr');
    final asrEnabled = await _prefsService.isAdhanEnabled('asr');
    final maghribEnabled = await _prefsService.isAdhanEnabled('maghrib');
    final ishaEnabled = await _prefsService.isAdhanEnabled('isha');

    setState(() {
      _adhanEnabled = adhanEnabled;
      _selectedSound = adhanSound;
      _prayerSettings = {
        'fajr': fajrEnabled,
        'dhuhr': dhuhrEnabled,
        'asr': asrEnabled,
        'maghrib': maghribEnabled,
        'isha': ishaEnabled,
      };
    });
  }

  Future<void> _toggleAdhan(bool value) async {
    await _prefsService.setAdhanNotificationsEnabled(value);
    setState(() {
      _adhanEnabled = value;
    });

    // Reschedule or cancel notifications
    if (value) {
      ref.invalidate(prayerTimesControllerProvider);
    } else {
      await _adhanService.cancelAllPrayers();
    }

    _showSnackBar(value ? 'تم تفعيل الأذان' : 'تم تعطيل الأذان');
  }

  Future<void> _togglePrayerAdhan(String prayerName, bool value) async {
    await _prefsService.setAdhanEnabled(prayerName, value);
    setState(() {
      _prayerSettings[prayerName] = value;
    });

    // Reschedule notifications
    ref.invalidate(prayerTimesControllerProvider);

    final prayerNameArabic = _getPrayerNameArabic(prayerName);
    _showSnackBar(value
        ? 'تم تفعيل أذان $prayerNameArabic'
        : 'تم تعطيل أذان $prayerNameArabic');
  }

  Future<void> _changeAdhanSound(String soundFile) async {
    await _prefsService.setAdhanSound(soundFile);
    setState(() {
      _selectedSound = soundFile;
    });
    _showSnackBar('تم تغيير صوت الأذان');
  }

  Future<void> _testAdhan() async {
    await _adhanService.testAdhan(_selectedSound);
    _showSnackBar('جاري تشغيل الأذان...');

    // Stop after 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      _adhanService.stopAdhan();
    });
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  String _getPrayerNameArabic(String prayerName) {
    switch (prayerName) {
      case 'fajr':
        return 'الفجر';
      case 'dhuhr':
        return 'الظهر';
      case 'asr':
        return 'العصر';
      case 'maghrib':
        return 'المغرب';
      case 'isha':
        return 'العشاء';
      default:
        return prayerName;
    }
  }

  String _getSoundDisplayName(String soundFile) {
    switch (soundFile) {
      case 'adhan_mecca.mp3':
        return 'أذان مكة المكرمة';
      case 'adhan_medina.mp3':
        return 'أذان المدينة المنورة';
      case 'adhan_egypt.mp3':
        return 'أذان مصر';
      case 'adhan_mishary.mp3':
        return 'أذان مشاري العفاسي';
      case 'adhan_turkey.mp3':
        return 'أذان تركيا';
      default:
        return soundFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الأذان'),
        centerTitle: true,
        backgroundColor: const Color(0xFF43A047),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Global Adhan Toggle
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: const Text(
                'تفعيل الأذان',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('تفعيل أو تعطيل جميع إشعارات الأذان'),
              value: _adhanEnabled,
              onChanged: _toggleAdhan,
              activeColor: const Color(0xFF43A047),
            ),
          ),

          const SizedBox(height: 16),

          // Adhan Sound Selector
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text(
                'صوت الأذان',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(_getSoundDisplayName(_selectedSound)),
              leading: const Icon(Icons.volume_up, color: Color(0xFF43A047)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showAdhanSoundDialog,
            ),
          ),

          const SizedBox(height: 24),

          // Per-Prayer Settings Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              'تفعيل الأذان لكل صلاة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF43A047),
              ),
            ),
          ),

          // Per-Prayer Toggles
          _buildPrayerToggle('fajr', 'الفجر', Icons.wb_twilight),
          _buildPrayerToggle('dhuhr', 'الظهر', Icons.wb_sunny),
          _buildPrayerToggle('asr', 'العصر', Icons.wb_sunny_outlined),
          _buildPrayerToggle('maghrib', 'المغرب', Icons.wb_incandescent),
          _buildPrayerToggle('isha', 'العشاء', Icons.nightlight_round),

          const SizedBox(height: 24),

          // Test Adhan Button
          ElevatedButton.icon(
            onPressed: _testAdhan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text(
              'اختبار الأذان',
              style: TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 16),

          // Info Card
          Card(
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'سيتم تشغيل الأذان تلقائياً في أوقات الصلاة حتى لو كان التطبيق مغلقاً',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerToggle(String prayerName, String arabicName, IconData icon) {
    final isEnabled = _prayerSettings[prayerName] ?? true;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(arabicName, style: const TextStyle(fontSize: 16)),
        value: isEnabled && _adhanEnabled,
        onChanged: _adhanEnabled ? (value) => _togglePrayerAdhan(prayerName, value) : null,
        secondary: Icon(icon, color: const Color(0xFF43A047)),
        activeColor: const Color(0xFF43A047),
      ),
    );
  }

  void _showAdhanSoundDialog() {
    final adhanSounds = {
      'adhan_mecca.mp3': 'أذان مكة المكرمة',
      'adhan_medina.mp3': 'أذان المدينة المنورة',
      'adhan_egypt.mp3': 'أذان مصر',
      'adhan_mishary.mp3': 'أذان مشاري العفاسي',
      'adhan_turkey.mp3': 'أذان تركيا',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر صوت الأذان'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: adhanSounds.entries.map((entry) {
              return RadioListTile<String>(
                value: entry.key,
                groupValue: _selectedSound,
                title: Text(entry.value),
                onChanged: (value) {
                  if (value != null) {
                    _changeAdhanSound(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: const Color(0xFF43A047),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}
