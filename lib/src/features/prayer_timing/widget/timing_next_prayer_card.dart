import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/time_format/time_format_bloc.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/controller/timing_controller.dart';
import '../../home/theme/home_theme.dart';
import '../../home/util/prayer_schedule_utils.dart';
import '../theme/prayer_timing_theme.dart';

class TimingNextPrayerCard extends StatefulWidget {
  const TimingNextPrayerCard({
    super.key,
    required this.next,
    required this.viewingToday,
  });

  final NextPrayerDetails next;
  final bool viewingToday;

  @override
  State<TimingNextPrayerCard> createState() => _TimingNextPrayerCardState();
}

class _TimingNextPrayerCardState extends State<TimingNextPrayerCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = widget.next.remaining;

    return BlocBuilder<TimeFormatBloc, TimeFormatState>(
      builder: (context, timeFormatState) {
        final scheduled = timeFormatState.is24
            ? widget.next.time
            : convertTimeTo12HourFormat(widget.next.time);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: PrayerTimingTheme.heroCardBg(context),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: kLightPrimary.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'NEXT PRAYER',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.next.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 18.sp,
                    color: HomeTheme.highlight,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    widget.viewingToday
                        ? formatPrayerCountdownHms(remaining)
                        : scheduled,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  'Scheduled for $scheduled',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w500,
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
