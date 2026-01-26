import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';

class PrayerSettingsPage extends StatelessWidget {
  const PrayerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات المواقيت'), 
        centerTitle: true,
        backgroundColor: const Color(0xFF43A047), // Matching Green Header
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Calculation Method Section (Future placeholder)
          ListTile(
            title: const Text('طريقة الحساب'),
            subtitle: const Text('رئاسة الشؤون الدينية (تركيا)'),
            leading: const Icon(Icons.calculate),
            onTap: () {
               // Show dialog to change calculation method
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم إضافته قريباً')));
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
            subtitle: const Text('تلقائي (GPS)'),
            leading: const Icon(Icons.location_on),
            trailing: Switch(value: true, onChanged: (val){}),
          ),
        ],
      ),
    );
  }
}
