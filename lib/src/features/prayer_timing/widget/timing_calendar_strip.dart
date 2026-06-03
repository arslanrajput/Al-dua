import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../home/theme/home_theme.dart';
import '../../home/util/prayer_schedule_utils.dart';
import '../theme/prayer_timing_theme.dart';

class TimingCalendarStrip extends StatelessWidget {
  const TimingCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  DateTime _weekStart(DateTime date) {
    final daysFromSunday = date.weekday % 7;
    return DateTime(date.year, date.month, date.day - daysFromSunday);
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = _weekStart(selectedDate);
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('MMMM yyyy').format(selectedDate),
                style: PrayerTimingTheme.monthTitleStyle(context),
              ),
            ),
            _NavButton(icon: Icons.chevron_left_rounded, onTap: onPreviousWeek),
            SizedBox(width: 8.w),
            _NavButton(icon: Icons.chevron_right_rounded, onTap: onNextWeek),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            for (final day in days)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: _DayChip(
                    day: day,
                    isSelected: isSameCalendarDay(day, selectedDate),
                    isToday: isSameCalendarDay(day, today),
                    onTap: () => onDateSelected(day),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HomeTheme.cardBackground(context),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 34.w,
          height: 34.w,
          child: Icon(
            icon,
            size: 22.sp,
            color: HomeTheme.primaryText(context),
          ),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isSelected
        ? Colors.white
        : HomeTheme.primaryText(context);

    return Material(
      color: isSelected
          ? PrayerTimingTheme.heroCardBg(context)
          : HomeTheme.cardBackground(context),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? null
                : Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
          ),
          child: Column(
            children: [
              Text(
                DateFormat('EEE').format(day).toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: labelColor.withValues(alpha: isSelected ? 0.85 : 0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('dd').format(day),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? HomeTheme.highlight
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
