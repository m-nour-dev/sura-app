import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/quran/presentation/riverpod/audio_controller.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_controller.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
      ),
      body: surahState.when(
        data: (surah) {
          if (surah.ayahs == null || surah.ayahs!.isEmpty) {
            return const Center(child: Text("Coming Soon (Verses data pending)"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surah.ayahs!.length,
            itemBuilder: (context, index) {
              final ayah = surah.ayahs![index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (ayah.audioUrl != null) {
                          try {
                            // Visual feedback
                            ref.read(playingAyahIdProvider.notifier).setPlaying(ayah.number);
                            
                            // Use the AudioController correctly
                            final audioController = ref.read(audioControllerProvider.notifier);
                            print("Attempting to play: ${ayah.audioUrl}");
                            await audioController.playAudio(ayah.audioUrl!);
                          } catch (e) {
                            // Reset playing state on error
                            ref.read(playingAyahIdProvider.notifier).setPlaying(null);
                            
                            if (!context.mounted) return;
                            
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                icon: Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 48,
                                ),
                                title: const Text("خطأ في تشغيل الصوت"),
                                content: const Text(
                                  "عذراً، لا يمكن تشغيل الصوت حالياً.\n\n"
                                  "يرجى التأكد من اتصالك بالإنترنت والمحاولة مرة أخرى."
                                ),
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
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: ref.watch(playingAyahIdProvider) == ayah.number
                              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Ayah Number
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Text(
                                    '${ayah.number}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (ayah.audioUrl != null)
                                  Icon(
                                    Icons.volume_up_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Arabic Text
                            Text(
                              ayah.text,
                              textAlign: TextAlign.center,
                              textDirection: ui.TextDirection.rtl,
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 26,
                                height: 2.0,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),
                            // Translation
                            Text(
                              ayah.translation,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
