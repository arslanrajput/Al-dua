import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/setting_theme.dart';

class PreferenceRow extends StatelessWidget {
  const PreferenceRow({
    super.key,
    required this.iconPath,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.showDivider = true,
  });

  final String iconPath;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? SettingTheme.iconTileBgDark
                      : SettingTheme.iconTileBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconPath,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: ColorFilter.mode(
                    SettingTheme.primaryText(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: SettingTheme.tileTitleStyle(context),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: SettingTheme.tileSubtitleStyle(context),
                      ),
                    ],
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 66.w,
            endIndent: 14.w,
            color: SettingTheme.divider(context),
          ),
      ],
    );
  }
}
