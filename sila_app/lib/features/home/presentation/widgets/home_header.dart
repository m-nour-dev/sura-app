import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    this.onNotificationTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning_greeting'.tr();
    } else if (hour < 18) {
      return 'afternoon_greeting'.tr();
    } else {
      return 'evening_greeting'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriCalendar.now();
    final locale = context.locale;
    
    final months = locale.languageCode == 'tr' ? [
      'Muharrem',
      'Safar',
      'Rebiülevvel',
      'Rebiülahir',
      'Cumadelüla',
      'Cumadelahir',
      'Recep',
      'Şaban',
      'Ramazan',
      'Şevval',
      'Zilkade',
      'Zilhicce',
    ] : locale.languageCode == 'en' ? [
      'Muharram',
      'Safar',
      "Rabi' Al-Awwal",
      "Rabi' Al-Akhir",
      'Jumada Al-Ula',
      'Jumada Al-Akhira',
      'Rajab',
      "Sha'ban",
      'Ramadan',
      'Shawwal',
      "Dhul Qi'dah",
      'Dhul Hijjah',
    ] : locale.languageCode == 'fr' ? [
      'Mouharram',
      'Safar',
      'Rabi\' Al-Awwal',
      'Rabi\' Al-Akhir',
      'Joumada Al-Oula',
      'Joumada Al-Akhira',
      'Rajab',
      'Cha\'bane',
      'Ramadan',
      'Chawwal',
      'Dhoul Qi\'dah',
      'Dhoul Hijjah',
    ] : [
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
    final month = months[(hijriDate.hMonth - 1).clamp(0, 11)];
    final hijriText = locale.languageCode == 'tr'
        ? '${hijriDate.hDay} $month ${hijriDate.hYear} H'
        : locale.languageCode == 'en'
        ? '${hijriDate.hDay} $month ${hijriDate.hYear} H'
        : locale.languageCode == 'fr'
        ? '${hijriDate.hDay} $month ${hijriDate.hYear} H'
        : '${hijriDate.hDay} $month ${hijriDate.hYear}هـ';

    return Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: GoogleFonts.getFont(
                          'Cairo',
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                       Text(
                         'welcome_message'.tr(),
                         style: GoogleFonts.getFont(
                           'Cairo',
                           fontSize: 20,
                           fontWeight: FontWeight.w700,
                           color: Colors.white,
                         ),
                       ),
                    ],
                  ),
                  Row(
                    children: [
                      const _LanguageHeaderButton(),
                      const SizedBox(width: 8),
                      // Bell Icon
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onNotificationTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
                            ),
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Hijri Date
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                   hijriText,
                   style: GoogleFonts.getFont(
                     'Cairo',
                     fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
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

class _LanguageHeaderButton extends StatelessWidget {
  const _LanguageHeaderButton();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      onSelected: (Locale locale) {
        context.setLocale(locale);
      },
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 50),
      color: Colors.white,
      itemBuilder: (BuildContext context) {
        return context.supportedLocales.map((locale) {
          final isSelected = context.locale == locale;
          final langName = locale.languageCode == 'ar'
              ? 'العربية'
              : locale.languageCode == 'tr'
              ? 'Türkçe'
              : locale.languageCode == 'fr'
              ? 'Français'
              : 'English';
          
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  langName,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF064E3B) : Colors.black87,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: Color(0xFF064E3B), size: 16),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        ),
        child: const Icon(
          Icons.language,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
