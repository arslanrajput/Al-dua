import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../home/theme/home_theme.dart';

/// Asma-ul-Husna list styling.
abstract class AllahNameTheme {
  AllahNameTheme._();

  static const Color indexBorder = Color(0xFFA89060);
  static const Color headerCardBg = Color(0xFFEDF1F0);
  static const Color headerCardBgDark = Color(0xFF152A22);

  static Color screenBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkBg
        : const Color(0xFFF5F7F6);
  }

  static Color headerBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? headerCardBgDark
        : headerCardBg;
  }

  static Color cardBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? HomeTheme.darkCardElevated
        : Colors.white;
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : kLightPrimary;
  }

  static Color mutedText(BuildContext context) {
    return HomeTheme.mutedText(context);
  }

  static TextStyle titleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: primaryText(context),
          fontSize: 22.sp,
        );
  }

  static TextStyle subtitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: mutedText(context),
          height: 1.45,
        );
  }

  static TextStyle transliterationStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: primaryText(context),
          letterSpacing: 0.6,
          fontSize: 14.sp,
        );
  }

  static TextStyle meaningStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: mutedText(context),
          fontSize: 13.sp,
        );
  }

  static TextStyle arabicStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Uthman',
          fontWeight: FontWeight.w600,
          color: primaryText(context),
          fontSize: 26.sp,
        );
  }
}
