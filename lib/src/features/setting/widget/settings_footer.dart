import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/util/constants.dart';
import '../theme/setting_theme.dart';

/// App name, version name, and build number (Android versionCode from Gradle).
class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final labelStyle = SettingTheme.tileSubtitleStyle(context).copyWith(
          fontWeight: FontWeight.w600,
        );
        final mutedStyle = SettingTheme.tileSubtitleStyle(context);

        if (!snapshot.hasData) {
          return Column(
            children: [
              Text(kAppDisplayName, style: labelStyle),
              SizedBox(height: 6.h),
              Text(
                'Made with devotion for the Ummah',
                style: mutedStyle,
              ),
            ],
          );
        }

        final info = snapshot.data!;
        return Column(
          children: [
            Text(
              '$kAppDisplayName v${info.version}',
              style: labelStyle,
            ),
            SizedBox(height: 4.h),
            Text(
              'Version code ${info.buildNumber}',
              style: mutedStyle,
            ),
            SizedBox(height: 6.h),
            Text(
              'Made with devotion for the Ummah',
              style: mutedStyle,
            ),
          ],
        );
      },
    );
  }
}
