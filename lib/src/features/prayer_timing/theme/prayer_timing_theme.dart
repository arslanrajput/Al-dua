import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../home/theme/home_theme.dart';

/// Prayer timing screen palette (matches Al-Dua mockup).
abstract class PrayerTimingTheme {
  PrayerTimingTheme._();

  static const Color heroGreen = Color(0xFF0B4D35);
  static const Color heroGreenDark = Color(0xFF0A3D2B);
  static const Color activeRowBg = Color(0xFFE8EEF4);
  static const Color activeRowBgDark = Color(0xFF1E3340);
  static const Color quoteBg = Color(0xFFFFF8E7);
  static const Color quoteBgDark = Color(0xFF2A2818);

  static Color screenBg(BuildContext context) => HomeTheme.screenBackground(context);

  static Color heroCardBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? heroGreenDark
        : heroGreen;
  }

  static Color quoteCardBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? quoteBgDark
        : quoteBg;
  }

  static Color activeScheduleBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? activeRowBgDark
        : activeRowBg;
  }

  static TextStyle monthTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: HomeTheme.primaryText(context),
        );
  }

  static TextStyle sectionLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          color: HomeTheme.mutedText(context),
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          fontSize: 11.sp,
        );
  }
}
