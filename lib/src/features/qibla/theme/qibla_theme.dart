import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../home/theme/home_theme.dart';

/// Qibla screen palette (Al-Dua mockup).
abstract class QiblaTheme {
  QiblaTheme._();

  static const Color locationChipBg = Color(0xFFF5E6C8);
  static const Color locationChipText = Color(0xFF5C4A2E);

  static BoxDecoration screenGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0E1F19), kDarkBg],
        ),
      );
    }
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE8EEF4), kLightBg],
        stops: [0.0, 0.45],
      ),
    );
  }

  static TextStyle headingStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: HomeTheme.primaryText(context),
          fontSize: 22.sp,
          height: 1.3,
        );
  }

  static TextStyle statValueStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? kDarkPrimary : kLightPrimary,
          fontSize: 22.sp,
        );
  }

  static TextStyle statLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          color: HomeTheme.mutedText(context),
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontSize: 10.sp,
        );
  }
}
