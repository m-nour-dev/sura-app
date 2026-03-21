import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/presentation/widgets/sila_app_bar.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/features/azkar/presentation/pages/tasbih_page.dart';
import 'package:sila_app/features/azkar/presentation/pages/azkar_detail_page.dart';
import 'package:sila_app/features/azkar/presentation/widgets/azkar_category_card.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_providers.dart';
import 'package:sila_app/features/notifications/presentation/pages/settings/azkar_notification_settings.dart';
import 'package:sila_app/features/notifications/presentation/widgets/streak_badge.dart';
import 'package:sila_app/features/sunan_mahjoura/presentation/pages/sunan_list_page.dart';

class AzkarPage extends ConsumerStatefulWidget {
  const AzkarPage({super.key});

  @override
  ConsumerState<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends ConsumerState<AzkarPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      try {
        final tracker = await ref.read(streakTrackerProvider.future);
        await tracker.logActivity('azkar');
      } catch (e, st) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: e,
            stack: st,
            library: 'azkar_page',
            context: ErrorDescription('while logging azkar activity streak'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SilaAppBar(
        title: 'azkar'.tr(),
        actions: [
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: StreakBadge(featureKey: 'azkar'),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const AzkarNotificationSettings()),
              );
            },
            icon: const Icon(Icons.notifications_active_rounded,
                color: Colors.white),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
        children: [
          AzkarCategoryCard(
            title: 'azkar_morning'.tr(),
            icon: Icons.wb_sunny_rounded,
            onTap: () {
              ref
                  .read(analyticsServiceProvider)
                  .logAzkarCategoryOpen(categoryName: 'morning');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AzkarDetailPage(
                    categoryId: 'morning',
                    title: 'azkar_morning'.tr(),
                  ),
                ),
              );
            },
          ),
          AzkarCategoryCard(
            title: 'azkar_evening'.tr(),
            icon: Icons.nights_stay_rounded,
            onTap: () {
              ref
                  .read(analyticsServiceProvider)
                  .logAzkarCategoryOpen(categoryName: 'evening');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AzkarDetailPage(
                    categoryId: 'evening',
                    title: 'azkar_evening'.tr(),
                  ),
                ),
              );
            },
          ),
          AzkarCategoryCard(
            title: 'azkar_sleep'.tr(),
            icon: Icons.bedtime_rounded,
            onTap: () {
              ref
                  .read(analyticsServiceProvider)
                  .logAzkarCategoryOpen(categoryName: 'sleep');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AzkarDetailPage(
                    categoryId: 'sleep',
                    title: 'azkar_sleep'.tr(),
                  ),
                ),
              );
            },
          ),
          AzkarCategoryCard(
            title: 'azkar_mosque'.tr(),
            icon: Icons.mosque_rounded,
            onTap: () {
              ref
                  .read(analyticsServiceProvider)
                  .logAzkarCategoryOpen(categoryName: 'mosque');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AzkarDetailPage(
                    categoryId: 'mosque',
                    title: 'azkar_mosque'.tr(),
                  ),
                ),
              );
            },
          ),
          AzkarCategoryCard(
            title: 'azkar_tasbih'.tr(),
            icon: Icons.touch_app_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TasbihPage()),
              );
            },
          ),
          AzkarCategoryCard(
            title: 'sunan_mahjoura'.tr(),
            icon: Icons.lightbulb_outline_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SunanListPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
