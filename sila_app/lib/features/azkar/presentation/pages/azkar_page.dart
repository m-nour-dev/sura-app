import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sila_app/features/azkar/presentation/pages/tasbih_page.dart';
import 'package:sila_app/features/azkar/presentation/pages/azkar_detail_page.dart'; // Import
import 'package:sila_app/features/azkar/presentation/widgets/azkar_category_card.dart';
import 'package:sila_app/features/sunan_mahjoura/presentation/pages/sunan_list_page.dart';

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('azkar'.tr()),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          AzkarCategoryCard(
            title: 'azkar_morning'.tr(),
            icon: Icons.wb_sunny_rounded,
            color: Colors.orange,
            onTap: () {
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
            color: Colors.indigo,
            onTap: () {
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
            color: Colors.purple,
            onTap: () {
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
            color: Colors.teal,
            onTap: () {
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
            color: Colors.green,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TasbihPage()),
              );
            },
          ),
          AzkarCategoryCard(
            title: 'sunan_mahjoura'.tr(),
            icon: Icons.lightbulb_outline_rounded,
            color: Colors.amber.shade700,
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
