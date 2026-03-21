import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_providers.dart';

class StreakBadge extends ConsumerWidget {
  final String featureKey;

  const StreakBadge({super.key, required this.featureKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoAsync = ref.watch(notificationRepositoryProvider);
    return repoAsync.when(
      data: (repo) {
        return FutureBuilder<int>(
          future: repo.getActivityLog(featureKey).then((e) => e.streakDays),
          builder: (context, snapshot) {
            final days = snapshot.data ?? 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Text(
                '✦ $days يوم',
                style: GoogleFonts.getFont(
                  'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF065F46),
                ),
              ),
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
