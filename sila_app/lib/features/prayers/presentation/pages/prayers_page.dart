import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:sila_app/features/prayers/presentation/widgets/location_settings_dialog.dart';

class PrayersPage extends ConsumerWidget {
  const PrayersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerState = ref.watch(prayerTimesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('prayers'.tr()),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => const LocationSettingsDialog(),
              );
              if (result == true) {
                 ref.invalidate(prayerTimesControllerProvider);
                 ref.invalidate(nextPrayerControllerProvider);
              }
            },
            icon: const Icon(Icons.edit_location_rounded),
          ),
        ],
      ),
      body: prayerState.when(
        data: (times) {
          final prayers = [
            {"name": "fajr", "time": DateFormat.jm().format(times.fajr), "isNext": false},
            {"name": "sunrise", "time": DateFormat.jm().format(times.sunrise), "isNext": false},
            {"name": "dhuhr", "time": DateFormat.jm().format(times.dhuhr), "isNext": false},
            {"name": "asr", "time": DateFormat.jm().format(times.asr), "isNext": false},
            {"name": "maghrib", "time": DateFormat.jm().format(times.maghrib), "isNext": false},
            {"name": "isha", "time": DateFormat.jm().format(times.isha), "isNext": false},
          ];

          return Column(
            children: [
              // Date Strip (Simple)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const Divider(height: 1),
              // Timetable
              Expanded(
                child: ListView.separated(
                  itemCount: prayers.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final prayer = prayers[index];
                    final isNext = prayer['isNext'] as bool; // Logic to check 'isNext' can be improved

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      leading: Icon(
                        prayer['name'] == 'sunrise' ? Icons.wb_sunny_outlined : Icons.access_time_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        (prayer['name'] as String).tr(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        prayer['time'] as String,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (e, st) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
