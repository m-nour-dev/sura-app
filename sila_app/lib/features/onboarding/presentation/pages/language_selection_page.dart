import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/core/presentation/main_layout.dart';
import 'package:sila_app/core/theme/app_theme.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  Future<void> _selectLanguage(BuildContext context, Locale locale) async {
    // Set locale
    await context.setLocale(locale);

    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_language_selected', true);

    if (!context.mounted) return;

    // Navigate to MainLayout
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Icon or Logo
              const Icon(
                Icons.language,
                size: 80,
                color: Color(0xFF064E3B),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'اختر اللغة',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF064E3B),
                ),
              ),
              Text(
                'Dil Seçin',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF064E3B),
                ),
              ),
              
              const SizedBox(height: 48),

              // Arabic Option
              _LanguageOptionCard(
                title: 'العربية',
                subtitle: 'Arabic',
                flag: '🇸🇦',
                onTap: () => _selectLanguage(context, const Locale('ar', 'SA')),
              ),

              const SizedBox(height: 16),

              // Turkish Option
              _LanguageOptionCard(
                title: 'Türkçe',
                subtitle: 'Turkish',
                flag: '🇹🇷',
                onTap: () => _selectLanguage(context, const Locale('tr', 'TR')),
              ),

              const Spacer(),
              
              // Footer text
              Text(
                'Sıla App',
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF064E3B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFFD97706),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
