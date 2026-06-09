import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/util/controller/url_launcher_controller.dart';
import '../model/social_media.dart';
import '../theme/setting_theme.dart';

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton(this.socialMedia, {super.key});

  final SocialMedia socialMedia;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: SettingTheme.surfaceCard(context),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => launchURL(socialMedia.url),
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: SettingTheme.cardShadow(context),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE8EEF4),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    socialMedia.imagePath,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: ColorFilter.mode(
                      SettingTheme.primaryText(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    socialMedia.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SettingTheme.tileSubtitleStyle(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
