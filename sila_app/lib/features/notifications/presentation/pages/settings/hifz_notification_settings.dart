import 'package:flutter/material.dart';
import 'package:sila_app/features/notifications/presentation/pages/settings/_notification_settings_sheet.dart';

class HifzNotificationSettings extends StatelessWidget {
  const HifzNotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: NotificationSettingsSheet(featureKey: 'hifz')),
    );
  }
}
