import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/home/presentation/widgets/daily_content_card.dart';
import 'package:sila_app/features/home/presentation/widgets/last_read_card.dart';
import 'package:sila_app/features/home/presentation/widgets/next_prayer_card.dart';
import 'package:sila_app/features/quran/presentation/pages/quran_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        centerTitle: false, // Dashboard style
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Toggle Language for testing
              if (context.locale.languageCode == 'ar') {
                context.setLocale(const Locale('tr', 'TR'));
              } else {
                context.setLocale(const Locale('ar', 'SA'));
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'welcome_message'.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: NextPrayerCard(),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: LastReadCard(),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DailyContentCard(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
