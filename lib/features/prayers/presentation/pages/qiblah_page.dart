import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sura_app/features/prayers/presentation/riverpod/prayer_controller.dart';

class QiblahPage extends ConsumerStatefulWidget {
  const QiblahPage({super.key});

  @override
  ConsumerState<QiblahPage> createState() => _QiblahPageState();
}

class _QiblahPageState extends ConsumerState<QiblahPage> {
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      setState(() {
        _hasPermissions = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Qiblah Direction').tr(),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: !_hasPermissions
          ? Center(
              child: ElevatedButton(
                onPressed: _checkPermissions,
                child: const Text('Allow Location Access').tr(),
              ),
            )
          : StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('error_reading_compass'
                          .tr(args: [snapshot.error.toString()])));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final direction = snapshot.data?.heading;

                // If device doesn't support compass
                if (direction == null) {
                  return Center(child: Text('no_compass'.tr()));
                }

                // Get Qibla Angle from coordinates
                final prayerState = ref.watch(prayerTimesControllerProvider);

                return prayerState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(
                      child: Text('error_location'.tr(args: [e.toString()]))),
                  data: (timesEntity) {
                    final coordinates = Coordinates(
                        timesEntity.latitude, timesEntity.longitude);
                    final qiblaAngle = Qibla(coordinates).direction;

                    // Calculate rotation
                    // We want the Qibla arrow to point to Qibla.
                    // The compass points North (0).
                    // If Qibla is at 130 degrees, and North is at 0 degrees.
                    // We rotate the compass dial by -heading.
                    // The Qibla needle should be fixed at Qibla angle relative to North on the dial.

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${direction.toStringAsFixed(0)}°',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(
                            'Qibla: ${qiblaAngle.toStringAsFixed(0)}°',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 50),

                          // Compass Stack
                          SizedBox(
                            width: 300,
                            height: 300,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Rotating Dial (North)
                                Transform.rotate(
                                  angle: direction * (math.pi / 180) * -1,
                                  child: Image.asset(
                                      'assets/images/compass_dial.png',
                                      errorBuilder: (_, __, ___) =>
                                          _buildCompassFallback()),
                                ),

                                // Qibla Needle (Points Calculated Direction relative to North)
                                // Actually simpler:
                                // Rotate the whole stack so North points up? No, usually compass mimics real compass.
                                // Let's say we rotate the background dial so North is correct relative to phone heading.
                                // Then we place Qibla icon at the Qibla angle on that dial.

                                Transform.rotate(
                                  angle: (direction - qiblaAngle) *
                                      (math.pi / 180) *
                                      -1,
                                  // Wait, if I rotate the needle, it should point to Qibla.
                                  // Formula: (QiblaAngle - PhoneHeading)

                                  child: Transform.rotate(
                                    angle: 0, // Reset logic
                                    child: Transform.rotate(
                                      angle: (qiblaAngle - direction) *
                                          (math.pi / 180),
                                      child: const Icon(Icons.navigation,
                                          size: 50, color: Colors.green),
                                      // This icon points UP by default. We want it to point towards Qibla.
                                      // Logic: Phone Heading = 0 (North). Qibla = 130. Arrow should point 130 deg right.
                                      // If Phone turns 10 deg right (Heading=10). We need arrow to point 120 deg right relative to phone.
                                      // Angle = Qibla - Heading. Correct.
                                    ),
                                  ),
                                ),

                                // Kaaba Icon in the middle (Static or directional?)
                                // Usually Qibla finders show an arrow pointing to it.
                                const Icon(Icons.mosque,
                                    size: 40, color: Colors.black54),
                              ],
                            ),
                          ),

                          const SizedBox(height: 50),
                          Text(
                            'place_device_flat'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildCompassFallback() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: const Center(
          child: Text('N', style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}

