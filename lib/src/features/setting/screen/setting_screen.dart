import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/setting_theme.dart';
import '../widget/general_card.dart';
import '../widget/settings_footer.dart';
import '../widget/social_media_card.dart';
import '../widget/user_preference_card.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
      backgroundColor: SettingTheme.background(context),
      appBar: AppBar(
        backgroundColor: SettingTheme.background(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('Settings', style: SettingTheme.appBarTitleStyle(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            const GeneralCard(),
            SizedBox(height: 20.h),
            const UserPreferenceCard(),
            SizedBox(height: 20.h),
            const SocialMediaCard(),
            SizedBox(height: 28.h),
            const Center(child: SettingsFooter()),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      ),
    );
  }
}
