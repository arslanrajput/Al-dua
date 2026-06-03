import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';

abstract class SettingTheme {
  SettingTheme._();

  static const Color screenBg = Color(0xFFF0F5FA);
  static const Color screenBgDark = Color(0xFF071510);
  static const Color cardBg = Colors.white;
  static const Color cardBgDark = Color(0xFF152A22);
  static const Color iconTileBg = Color(0xFFE5F3ED);
  static const Color iconTileBgDark = Color(0xFF1A3329);
  static const Color themePillActive = Color(0xFFDCE9F5);

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? screenBgDark
        : screenBg;
  }

  static Color surfaceCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardBgDark
        : cardBg;
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkTextColor
        : kBrandLogoGreen;
  }

  static Color mutedText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF6B7C75);
  }

  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.1)
        : const Color(0xFFE8EEF4);
  }

  static Color chevron(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0xFFB0BEC5);
  }

  static TextStyle appBarTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: primaryText(context),
          fontSize: 20.sp,
        );
  }

  static TextStyle sectionTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: primaryText(context),
          fontSize: 20.sp,
        );
  }

  static TextStyle tileTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: primaryText(context),
          fontSize: 16.sp,
        );
  }

  static TextStyle tileSubtitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: mutedText(context),
          fontSize: 13.sp,
        );
  }

  static List<BoxShadow> cardShadow(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) return const [];
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ];
  }
}
