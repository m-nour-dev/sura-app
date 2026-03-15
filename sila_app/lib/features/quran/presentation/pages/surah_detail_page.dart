import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/quran/domain/entities/quran_settings.dart';
import 'package:sila_app/features/quran/presentation/riverpod/audio_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_settings_controller.dart';

class SurahDetailPage extends ConsumerWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahState = ref.watch(surahDetailControllerProvider(surahNumber));
    final settingsState = ref.watch(quranSettingsControllerProvider);

    return settingsState.when(
      data: (settings) => Scaffold(
        backgroundColor: _getBackgroundColor(settings.themeMode),
        appBar: AppBar(
          title: Text(
            surahName,
            style: TextStyle(color: _getTextColor(settings.themeMode)),
          ),
          backgroundColor: _getBackgroundColor(settings.themeMode),
          iconTheme: IconThemeData(color: _getTextColor(settings.themeMode)),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showSettingsDialog(context, ref, settings),
            ),
          ],
        ),
        body: surahState.when(
          data: (surah) {
            if (surah.ayahs == null || surah.ayahs!.isEmpty) {
              return Center(
                child: Text(
                  "Coming Soon (Verses data pending)",
                  style: TextStyle(color: _getTextColor(settings.themeMode)),
                ),
              );
            }
            return PageView.builder(
              reverse: true, // RTL Swipe
              itemCount: surah.ayahs!.length,
              itemBuilder: (context, index) {
                final ayah = surah.ayahs![index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Ayah Number
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getAccentColor(settings.themeMode).withOpacity(0.2),
                        ),
                        child: Text(
                          '${ayah.number}',
                          style: TextStyle(
                            color: _getAccentColor(settings.themeMode),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Arabic Text
                      GestureDetector(
                        onTap: () async {
                          if (ayah.audioUrl != null) {
                            try {
                              ref.read(playingAyahIdProvider.notifier).setPlaying(ayah.number);
                              final audioController = ref.read(audioControllerProvider.notifier);
                              await audioController.playAudio(ayah.audioUrl!);
                            } catch (e) {
                              ref.read(playingAyahIdProvider.notifier).setPlaying(null);
                              if (!context.mounted) return;
                              _showErrorDialog(context);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ref.watch(playingAyahIdProvider) == ayah.number
                                ? _getAccentColor(settings.themeMode).withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            ayah.text,
                            textAlign: TextAlign.center,
                            textDirection: ui.TextDirection.rtl,
                            style: GoogleFonts.getFont(
                              settings.fontFamily,
                              fontSize: settings.fontSize,
                              height: 2.2,
                              color: _getTextColor(settings.themeMode),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Divider(indent: 40, endIndent: 40, color: Colors.grey),
                      const SizedBox(height: 32),
                      // Translation
                      Text(
                        ayah.translation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: _getTextColor(settings.themeMode).withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (ayah.audioUrl != null)
                        Icon(
                          Icons.volume_up_rounded,
                          color: _getAccentColor(settings.themeMode),
                          size: 32,
                        ),
                    ],
                  ),
                );
              },
            );
          },
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => Scaffold(body: Center(child: Text('Error loading settings: $error'))),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Color _getBackgroundColor(QuranThemeMode mode) {
    switch (mode) {
      case QuranThemeMode.light:
        return Colors.white;
      case QuranThemeMode.dark:
        return const Color(0xFF121212);
      case QuranThemeMode.sepia:
        return const Color(0xFFF4ECD8);
    }
  }

  Color _getTextColor(QuranThemeMode mode) {
    switch (mode) {
      case QuranThemeMode.light:
        return Colors.black87;
      case QuranThemeMode.dark:
        return Colors.white70;
      case QuranThemeMode.sepia:
        return const Color(0xFF5B4636);
    }
  }

  Color _getAccentColor(QuranThemeMode mode) {
    switch (mode) {
      case QuranThemeMode.light:
        return const Color(0xFF0F766E);
      case QuranThemeMode.dark:
        return const Color(0xFFCA8A04);
      case QuranThemeMode.sepia:
        return const Color(0xFF8D6E63);
    }
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref, QuranSettings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _getBackgroundColor(settings.themeMode),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "إعدادات القراءة",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getTextColor(settings.themeMode),
              ),
            ),
            const SizedBox(height: 24),
            // Theme Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildThemeOption(ref, QuranThemeMode.light, "فاتح", settings),
                _buildThemeOption(ref, QuranThemeMode.sepia, "كتابي", settings),
                _buildThemeOption(ref, QuranThemeMode.dark, "داكن", settings),
              ],
            ),
            const SizedBox(height: 32),
            // Font Selection
            DropdownButtonFormField<String>(
              value: settings.fontFamily,
              dropdownColor: _getBackgroundColor(settings.themeMode),
              style: TextStyle(color: _getTextColor(settings.themeMode)),
              decoration: InputDecoration(
                labelText: "نوع الخط",
                labelStyle: TextStyle(color: _getTextColor(settings.themeMode)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [
                const DropdownMenuItem(value: "Amiri", child: Text("Amiri (ميري)")),
                const DropdownMenuItem(value: "Noto Naskh Arabic", child: Text("Noto Naskh")),
                const DropdownMenuItem(value: "Scheherazade New", child: Text("Scheherazade")),
              ],
              onChanged: (val) {
                if (val != null) {
                  ref.read(quranSettingsControllerProvider.notifier).updateFontFamily(val);
                }
              },
            ),
            const SizedBox(height: 24),
            // Font Size
            Row(
              children: [
                Icon(Icons.format_size, color: _getTextColor(settings.themeMode)),
                Expanded(
                  child: Slider(
                    value: settings.fontSize,
                    min: 20,
                    max: 40,
                    divisions: 10,
                    activeColor: _getAccentColor(settings.themeMode),
                    onChanged: (val) {
                      ref.read(quranSettingsControllerProvider.notifier).updateFontSize(val);
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

  Widget _buildThemeOption(WidgetRef ref, QuranThemeMode mode, String label, QuranSettings settings) {
    final isSelected = settings.themeMode == mode;
    return GestureDetector(
      onTap: () => ref.read(quranSettingsControllerProvider.notifier).updateThemeMode(mode),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getBackgroundColor(mode),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? _getAccentColor(settings.themeMode) : Colors.grey,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: _getTextColor(settings.themeMode),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("خطأ في تشغيل الصوت"),
        content: const Text("عذراً، لا يمكن تشغيل الصوت حالياً."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("حسناً"),
          ),
        ],
      ),
    );
  }
}
