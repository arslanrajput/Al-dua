import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../routes/routes.dart';
import '../../../core/util/constants.dart';
import '../widget/permission_page_layout.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionPageLayout(
      icon: Icons.notifications_active_rounded,
      lottieAsset:
          'assets/images/permission/lottie_json/notification_permission.json',
      title: 'Prayer time notifications',
      description:
          'Allow $kAppDisplayName to remind you at each prayer time with '
          'optional Azan sound.',
      bullets: const [
        'On-time Fajr, Dhuhr, Asr, Maghrib & Isha alerts',
        'Choose which prayers to notify you for',
        'Enable or mute Azan sound per your preference',
      ],
      primaryButtonText: 'Allow notifications',
      onPrimaryPressed: () async {
        await Permission.notification.request();
        if (!context.mounted) return;
        Navigator.of(context).pushReplacementNamed(RouteGenerator.tabScreen);
      },
      secondaryButtonText: 'Not now',
      onSecondaryPressed: () {
        Navigator.of(context).pushReplacementNamed(RouteGenerator.tabScreen);
      },
    );
  }
}
