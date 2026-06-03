import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/theme/home_theme.dart';
import '../theme/prayer_timing_theme.dart';

class TimingQuoteCard extends StatelessWidget {
  const TimingQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: PrayerTimingTheme.quoteCardBg(context),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        '"The best of deeds is the prayer at its earliest time."',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: HomeTheme.primaryText(context),
              fontStyle: FontStyle.italic,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
