import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/social_media.dart';
import '../theme/setting_theme.dart';
import 'social_media_button.dart';

class SocialMediaCard extends StatelessWidget {
  const SocialMediaCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connect', style: SettingTheme.sectionTitleStyle(context)),
          SizedBox(height: 12.h),
          Row(
            children: [
              for (var i = 0; i < socialMediaList.length; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                SocialMediaButton(socialMediaList[i]),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
