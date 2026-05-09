import 'package:flutter/material.dart';
import 'package:sura_app/features/notifications/presentation/pages/settings/_notification_settings_sheet.dart';

class TasbihNotificationSettings extends StatelessWidget {
  const TasbihNotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: NotificationSettingsSheet(featureKey: 'tasbih')),
    );
  }
}

