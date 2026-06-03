import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/theme/home_theme.dart';

abstract class AzkarTheme {
  AzkarTheme._();

  static const Color screenBg = Color(0xFFF0F5FA);
  static const Color screenBgDark = Color(0xFF071510);
  static const Color languageChipBg = Color(0xFFE8EEF4);
  static const Color languageChipBgDark = Color(0xFF1E3340);
  static const Color footerCardBg = Color(0xFFDCE9F5);
  static const Color footerCardBgDark = Color(0xFF122430);
  static const Color iconCircleBg = Color(0xFFE0F2EC);
  static const Color iconCircleBgDark = Color(0xFF163528);
  static const Color iconTileBg = Color(0xFFE5F3ED);
  static const Color iconTileBgDark = Color(0xFF1A3329);

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? screenBgDark
        : screenBg;
  }

  static Color primaryText(BuildContext context) => HomeTheme.primaryText(context);

  static Color mutedText(BuildContext context) => HomeTheme.mutedText(context);

  static TextStyle sectionLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          color: mutedText(context),
          fontWeight: FontWeight.w600,
          letterSpacing: 1.3,
          fontSize: 11.sp,
        );
  }

  static TextStyle pageTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: primaryText(context),
          fontSize: 26.sp,
          height: 1.2,
        );
  }

  static TextStyle sectionTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: primaryText(context),
          fontSize: 20.sp,
        );
  }
}
