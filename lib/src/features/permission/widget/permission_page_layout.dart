import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/util/constants.dart';
import '../../home/theme/home_theme.dart';

/// Shared layout for onboarding permission screens (Al-Dua brand).
class PermissionPageLayout extends StatelessWidget {
  const PermissionPageLayout({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    required this.secondaryButtonText,
    required this.onSecondaryPressed,
    this.bullets,
    this.lottieAsset,
  });

  final IconData icon;
  final String title;
  final String description;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String secondaryButtonText;
  final VoidCallback onSecondaryPressed;
  final List<String>? bullets;
  final String? lottieAsset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? kDarkBg : kLightBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                kAppDisplayName,
                style: TextStyle(
                  color: HomeTheme.accent,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (lottieAsset != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 0.28.sh,
                    maxWidth: 280.w,
                  ),
                  child: LottieBuilder.asset(lottieAsset!),
                )
              else
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HomeTheme.accent.withValues(alpha: 0.12),
                    border: Border.all(
                      color: HomeTheme.accent.withValues(alpha: 0.35),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 44.sp,
                    color: HomeTheme.accent,
                  ),
                ),
              SizedBox(height: 28.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : kLightTextColor,
                    ),
              ),
              SizedBox(height: 12.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? const Color(0xFF8FA89C)
                          : const Color(0xFF5C7268),
                      height: 1.45,
                    ),
              ),
              if (bullets != null && bullets!.isNotEmpty) ...[
                SizedBox(height: 20.h),
                ...bullets!.map(
                  (text) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, right: 10.w),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 18.sp,
                            color: HomeTheme.accent,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.85)
                                      : kLightTextColor,
                                  height: 1.35,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onPrimaryPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? kDarkPrimary : kLightPrimary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    primaryButtonText,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: onSecondaryPressed,
                child: Text(
                  secondaryButtonText,
                  style: TextStyle(
                    color: HomeTheme.accent,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
