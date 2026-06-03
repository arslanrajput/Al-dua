import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/time_format/time_format_bloc.dart';
import '../../../core/util/controller/timing_controller.dart';
import '../theme/home_theme.dart';

/// One prayer = one standalone card (matches home mockup).
class PrayerTimeListTile extends StatelessWidget {
  const PrayerTimeListTile({
    super.key,
    required this.name,
    required this.time,
    required this.isNext,
  });

  final String name;
  final String time;
  final bool isNext;

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
        return Icons.bedtime_outlined;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isNext
        ? HomeTheme.highlight
        : (isDark ? HomeTheme.darkCardElevated : Colors.white);

    final textColor =
        isNext ? const Color(0xFF3D3420) : HomeTheme.primaryText(context);

    final iconColor = isNext
        ? const Color(0xFF3D3420).withValues(alpha: 0.75)
        : HomeTheme.mutedText(context);

    final nameStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: textColor,
    );

    final timeStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w500,
      color: textColor,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isNext
              ? const Color(0xFF8B6914).withValues(alpha: 0.45)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.07)),
          width: 1,
        ),
        boxShadow: isNext
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              _iconForPrayer(name),
              size: 28.sp,
              color: iconColor,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(name, style: nameStyle),
            ),
            BlocBuilder<TimeFormatBloc, TimeFormatState>(
              builder: (context, timeFormatState) {
                final formatted = timeFormatState.is24
                    ? time
                    : convertTimeTo12HourFormat(time);
                return Text(formatted, style: timeStyle);
              },
            ),
          ],
        ),
      ),
    );
  }
}
