import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../../core/util/theme.dart';

/// Shared palette for the home screen (Al-Dua mockup).
abstract class HomeTheme {
  HomeTheme._();

  static const Color accent = kDarkPrimary;
  static const Color accentBright = kDarkAccent;
  static const Color highlight = Color(0xFFE8C547);
  static const Color featureTileBg = Color(0xFFE8F0F5);
  static const Color featureTileBgDark = Color(0xFF152A22);
  static const Color progressCardBg = Color(0xFFE0F2EC);
  static const Color progressCardBgDark = Color(0xFF132820);
  static const Color challengeCardBg = Color(0xFFDCE9F5);
  static const Color challengeCardBgDark = Color(0xFF122430);

  static const Color darkScreen = kDarkBg;
  static const Color darkCard = Color(0xFF0F2219);
  static const Color darkCardElevated = Color(0xFF163528);

  static const Color nextPrayerGreen = Color(0xFF0B4D35);
  static const Color nextPrayerGreenDark = Color(0xFF0A3D2B);

  static Color screenBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkScreen
        : kLightBg;
  }

  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCard
        : Colors.white;
  }

  static Color cardBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkPrimary.withValues(alpha: 0.15)
        : kLightPrimary.withValues(alpha: 0.12);
  }

  static Color mutedText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF8FA89C)
        : const Color(0xFF5C7268);
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : kLightTextColor;
  }

  static Color sectionLabel(BuildContext context) {
    return mutedText(context);
  }

  static TextStyle sectionTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: sectionLabel(context),
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        );
  }

  static TextStyle appTitleStyle(BuildContext context) {
    return appBarTitleTextStyle(
      color: primaryText(context),
      fontSize: 26.sp,
    );
  }

  static TextStyle scheduleTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: primaryText(context),
        );
  }

  static Color featureTileColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? featureTileBgDark
        : featureTileBg;
  }
}
