import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../theme/setting_theme.dart';

class ChangeThemeSwitch extends StatelessWidget {
  const ChangeThemeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 112.w,
        height: 36.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: isDark
              ? const Color(0xFF1E3340)
              : const Color(0xFFE8EEF4),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: kAnimationDuration,
              curve: kAnimationCurve,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 52.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? kBrandLogoGreen
                      : SettingTheme.themePillActive,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Light',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: !value
                          ? SettingTheme.primaryText(context)
                          : SettingTheme.mutedText(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Dark',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: value
                          ? (isDark ? Colors.white : SettingTheme.primaryText(context))
                          : SettingTheme.mutedText(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
