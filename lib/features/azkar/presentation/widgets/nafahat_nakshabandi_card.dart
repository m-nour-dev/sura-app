import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/azkar/presentation/widgets/azkar_category_card.dart';
import 'package:sila_app/features/azkar/presentation/pages/nafahat_nakshabandi_page.dart';
import 'package:sila_app/core/services/analytics_service.dart';

class NafahatNakshabandiCard extends ConsumerWidget {
  const NafahatNakshabandiCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AzkarCategoryCard(
      title: 'spiritual_nafahat'.tr(),
      icon: Icons.mic_external_on_rounded,
      onTap: () {
        ref
            .read(analyticsServiceProvider)
            .logAzkarCategoryOpen(categoryName: 'nafahat');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NafahatNakshabandiPage(),
          ),
        );
      },
    );
  }
}
