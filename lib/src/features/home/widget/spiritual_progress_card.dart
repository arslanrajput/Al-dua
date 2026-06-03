import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/constants.dart';
import '../theme/home_theme.dart';
import '../util/prayer_schedule_utils.dart';

class SpiritualProgressCard extends StatelessWidget {
  const SpiritualProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<TimingBloc, TimingState>(
      builder: (context, state) {
        final completed = state is TimingLoaded
            ? completedPrayersToday(state.timing.data.timings)
            : 0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isDark
                ? HomeTheme.progressCardBgDark
                : HomeTheme.progressCardBg,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kLightPrimary.withValues(alpha: 0.15),
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: isDark ? HomeTheme.accent : kLightPrimary,
                  size: 26.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  "You've completed $completed/5 prayers today. MashaAllah!",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: HomeTheme.primaryText(context),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
