import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/home/presentation/widgets/daily_content_card.dart';
import 'package:sila_app/features/home/presentation/widgets/home_header.dart';
import 'package:sila_app/features/wird/presentation/widgets/wird_card.dart';
import 'package:sila_app/core/theme/app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeader(),
            // WirdCard overlaps header by 28px using its own Transform
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const WirdCard(),
                  const SizedBox(height: 24),
                  const DailyContentCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
