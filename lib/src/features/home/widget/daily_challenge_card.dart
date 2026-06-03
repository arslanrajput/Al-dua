import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../routes/routes.dart';
import '../theme/home_theme.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? HomeTheme.challengeCardBgDark : HomeTheme.challengeCardBg,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(RouteGenerator.quran),
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Memorize Surah Al-Ikhlas with translation.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: HomeTheme.primaryText(context),
                    height: 1.35,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: HomeTheme.mutedText(context),
                size: 28.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
