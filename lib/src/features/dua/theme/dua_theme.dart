import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../../core/util/theme.dart';
import '../../home/theme/home_theme.dart';

/// Dua list & card styling (Al-Dua mockup).
abstract class DuaTheme {
  DuaTheme._();

  static const Color screenBg = Color(0xFFF0F5FA);
  static const Color screenBgDark = Color(0xFF071510);
  static const Color categoryCardBg = Color(0xFFE8EEF4);
  static const Color categoryCardBgDark = Color(0xFF152A22);

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? screenBgDark
        : screenBg;
  }

  static Color categoryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? categoryCardBgDark
        : categoryCardBg;
  }

  static Color contentCardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0F2219)
        : Colors.white;
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkTextColor
        : kBrandLogoGreen;
  }

  static Color mutedText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF6B7C75);
  }

  static Color chevronColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.5)
        : const Color(0xFF8A9A94);
  }

  static Color indexBadgeBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? HomeTheme.nextPrayerGreenDark
        : kBrandLogoGreen;
  }

  static Color dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.12)
        : const Color(0xFFD5DEE8);
  }

  static Color categoryBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD5DEE8);
  }

  static TextStyle appBarTitleStyle(BuildContext context) {
    return appBarTitleTextStyle(
      color: primaryText(context),
      fontSize: 20.sp,
    );
  }

  static List<BoxShadow> categoryCardShadow(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) return const [];
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> contentCardShadow(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ];
  }
}
