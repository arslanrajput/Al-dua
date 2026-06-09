import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../../core/util/bloc/time_format/time_format_bloc.dart';
import '../../../core/util/controller/timing_controller.dart';
import '../../home/theme/home_theme.dart';
import '../theme/prayer_timing_theme.dart';

class TimingScheduleTile extends StatelessWidget {
  const TimingScheduleTile({
    super.key,
    required this.name,
    required this.time,
    required this.isActive,
  });

  final String name;
  final String time;
  final bool isActive;

  IconData _iconForPrayer(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight_rounded;
      case 'dhuhr':
        return Icons.wb_sunny_rounded;
      case 'asr':
        return Icons.wb_sunny_outlined;
      case 'maghrib':
        return Icons.wb_twilight_outlined;
      case 'isha':
        return Icons.nightlight_round;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isActive
        ? PrayerTimingTheme.activeScheduleBg(context)
        : HomeTheme.cardBackground(context);

    final textColor = HomeTheme.primaryText(context);
    final muted = HomeTheme.mutedText(context);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isActive
              ? kLightPrimary.withValues(alpha: 0.2)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06)),
        ),
        boxShadow: isActive
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? PrayerTimingTheme.heroCardBg(context)
                    : (isDark
                        ? HomeTheme.darkCardElevated
                        : const Color(0xFFF0F5F2)),
              ),
              child: Icon(
                _iconForPrayer(name),
                size: 22.sp,
                color: isActive ? Colors.white : muted,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  BlocBuilder<TimeFormatBloc, TimeFormatState>(
                    builder: (context, timeFormatState) {
                      final formatted = timeFormatState.is24
                          ? time
                          : convertTimeTo12HourFormat(time);
                      return Text(
                        formatted,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

