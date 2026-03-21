import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/notifications/presentation/pages/settings/azkar_notification_settings.dart';
import 'package:sila_app/features/notifications/presentation/pages/settings/hifz_notification_settings.dart';
import 'package:sila_app/features/notifications/presentation/pages/settings/salah_notification_settings.dart';
import 'package:sila_app/features/notifications/presentation/pages/settings/tasbih_notification_settings.dart';
import 'package:sila_app/features/notifications/presentation/pages/settings/wird_notification_settings.dart';

class NotificationHubPage extends StatelessWidget {
  const NotificationHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC);
    final card = isDark ? const Color(0xFF111827) : Colors.white;
    final border = isDark ? const Color(0xFF243041) : const Color(0xFFE2E8F0);
    final title = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF065F46),
        foregroundColor: Colors.white,
        title: Text('الإشعارات الذكية', style: GoogleFonts.getFont('Cairo', fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HubTile(
            title: 'إعدادات الصلاة',
            subtitle: 'تنبيهات الصلاة وما قبل الأذان',
            icon: Icons.mosque_rounded,
            card: card,
            border: border,
            titleColor: title,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SalahNotificationSettings()),
            ),
          ),
          _HubTile(
            title: 'إعدادات الورد',
            subtitle: 'وقت وردك القرآني والتكرار',
            icon: Icons.menu_book_rounded,
            card: card,
            border: border,
            titleColor: title,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WirdNotificationSettings()),
            ),
          ),
          _HubTile(
            title: 'إعدادات الأذكار',
            subtitle: 'الصباح والمساء وتنبيه نهاية الوقت',
            icon: Icons.wb_sunny_rounded,
            card: card,
            border: border,
            titleColor: title,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AzkarNotificationSettings()),
            ),
          ),
          _HubTile(
            title: 'إعدادات الحفظ',
            subtitle: 'تنبيهات الحفظ والتسميع',
            icon: Icons.school_rounded,
            card: card,
            border: border,
            titleColor: title,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HifzNotificationSettings()),
            ),
          ),
          _HubTile(
            title: 'إعدادات التسبيح',
            subtitle: 'ذكر يومي ثابت أو ذكي',
            icon: Icons.auto_awesome_rounded,
            card: card,
            border: border,
            titleColor: title,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TasbihNotificationSettings()),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color card;
  final Color border;
  final Color titleColor;
  final VoidCallback onTap;

  const _HubTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.card,
    required this.border,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF065F46), size: 18),
        ),
        title: Text(
          title,
          style: GoogleFonts.getFont('Cairo', fontWeight: FontWeight.w700, color: titleColor),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.getFont('Cairo', fontSize: 11),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      ),
    );
  }
}
