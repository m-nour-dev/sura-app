import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/quran/presentation/pages/surah_detail_page.dart';
import 'package:sila_app/features/quran/presentation/riverpod/quran_controller.dart';

class QuranPage extends ConsumerWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranState = ref.watch(quranControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('quran'.tr()),
      ),
      body: quranState.when(
        data: (surahs) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: surahs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    '${surah.number}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  context.locale.languageCode == 'ar'
                      ? surah.nameArabic
                      : surah.nameTurkish,
                  style: const TextStyle(
                    fontFamily: 'Amiri', // Ensure Arabic font is used if available, or fallback
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${surah.englishName} • ${surah.numberOfAyahs} Ayahs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Text(
                  surah.revelationType,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SurahDetailPage(
                        surahNumber: surah.number,
                        surahName: context.locale.languageCode == 'ar'
                            ? surah.nameArabic
                            : surah.nameTurkish,
                      ),
                    ),
                  );
                },
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
