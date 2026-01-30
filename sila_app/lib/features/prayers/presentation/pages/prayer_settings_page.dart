import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/adhan_settings_page.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';

class PrayerSettingsPage extends ConsumerStatefulWidget {
  const PrayerSettingsPage({super.key});

  @override
  ConsumerState<PrayerSettingsPage> createState() => _PrayerSettingsPageState();
}

class _PrayerSettingsPageState extends ConsumerState<PrayerSettingsPage> {
  String _currentMethod = 'turkey';
  bool _isAutoLocation = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = PrefsService();
    final method = await prefs.getCalculationMethod();
    final isAuto = await prefs.isAutoLocation();
    
    setState(() {
      _currentMethod = method;
      _isAutoLocation = isAuto;
    });
  }

  Future<void> _showCalculationMethodDialog() async {
    final methods = {
      'turkey': {'name': 'رئاسة الشؤون الدينية (تركيا)', 'desc': 'Diyanet Turkey'},
      'muslim_world_league': {'name': 'رابطة العالم الإسلامي', 'desc': 'Muslim World League'},
      'egyptian': {'name': 'هيئة المساحة المصرية', 'desc': 'Egyptian General Authority'},
      'umm_al_qura': {'name': 'أم القرى (مكة المكرمة)', 'desc': 'Umm al-Qura University'},
      'karachi': {'name': 'جامعة العلوم الإسلامية (كراتشي)', 'desc': 'University of Islamic Sciences, Karachi'},
      'dubai': {'name': 'الإمارات العربية المتحدة', 'desc': 'Dubai'},
      'qatar': {'name': 'دولة قطر', 'desc': 'Qatar'},
      'kuwait': {'name': 'دولة الكويت', 'desc': 'Kuwait'},
      'singapore': {'name': 'سنغافورة', 'desc': 'Singapore'},
      'north_america': {'name': 'أمريكا الشمالية (ISNA)', 'desc': 'Islamic Society of North America'},
    };

    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر طريقة الحساب'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: methods.entries.map((entry) {
              return RadioListTile<String>(
                value: entry.key,
                groupValue: _currentMethod,
                title: Text(entry.value['name']!),
                subtitle: Text(entry.value['desc']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                onChanged: (value) {
                  Navigator.pop(context, value);
                },
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

    if (selected != null && selected != _currentMethod) {
      final prefs = PrefsService();
      await prefs.setCalculationMethod(selected);
      
      setState(() {
        _currentMethod = selected;
      });

      // Invalidate prayer times to trigger recalculation
      ref.invalidate(prayerTimesControllerProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث طريقة الحساب')),
        );
      }
    }
  }

  String _getMethodDisplayName(String method) {
    final names = {
      'turkey': 'رئاسة الشؤون الدينية (تركيا)',
      'muslim_world_league': 'رابطة العالم الإسلامي',
      'egyptian': 'هيئة المساحة المصرية',
      'umm_al_qura': 'أم القرى (مكة المكرمة)',
      'karachi': 'جامعة العلوم الإسلامية',
      'dubai': 'الإمارات',
      'qatar': 'قطر',
      'kuwait': 'الكويت',
      'singapore': 'سنغافورة',
      'north_america': 'أمريكا الشمالية (ISNA)',
    };
    return names[method] ?? method;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات المواقيت'), 
        centerTitle: true,
        backgroundColor: const Color(0xFF43A047),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Calculation Method Section
          ListTile(
            title: const Text('طريقة الحساب'),
            subtitle: Text(_getMethodDisplayName(_currentMethod)),
            leading: const Icon(Icons.calculate),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showCalculationMethodDialog,
          ),
          const Divider(),
          
          // Adhan Settings
          ListTile(
            title: const Text('إعدادات الأذان'),
            subtitle: const Text('صوت الأذان والإشعارات'),
            leading: const Icon(Icons.notifications_active),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const AdhanSettingsPage()));
            },
          ),
          const Divider(),
          
          // Qiblah
          ListTile(
            title: const Text('اتجاه القبلة'),
            leading: const Icon(Icons.compass_calibration),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblahPage()));
            },
          ),
          const Divider(),
          
          // Location Settings
          ListTile(
            title: const Text('تحديد الموقع'),
            subtitle: Text(_isAutoLocation ? 'تلقائي (GPS)' : 'يدوي'),
            leading: const Icon(Icons.location_on),
            trailing: Switch(
              value: _isAutoLocation, 
              onChanged: (val) async {
                final prefs = PrefsService();
                await prefs.setAutoLocation(val);
                setState(() {
                  _isAutoLocation = val;
                });
                
                // Invalidate prayer times to trigger recalculation
                ref.invalidate(prayerTimesControllerProvider);
              },
            ),
          ),
        ],
      ),
    );
  }
}
