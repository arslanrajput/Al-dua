import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/general_option.dart';
import '../theme/setting_theme.dart';
import 'setting_tile.dart';

class GeneralCard extends StatelessWidget {
  const GeneralCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('General', style: SettingTheme.sectionTitleStyle(context)),
          SizedBox(height: 12.h),
          ...List.generate(generalOptions.length, (index) {
            final option = generalOptions[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: SettingTile(
                title: option.title,
                iconPath: option.imagePath,
                onTap: option.onTap ??
                    () {
                      Navigator.of(context)
                          .pushNamed(option.routeName!);
                    },
              ),
            );
          }),
        ],
      ),
    );
  }
}
