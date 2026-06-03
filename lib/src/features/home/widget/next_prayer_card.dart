import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/location_display.dart';
import '../../../core/util/constants.dart';
import '../theme/home_theme.dart';
import '../util/prayer_schedule_utils.dart';

class NextPrayerCard extends StatefulWidget {
  const NextPrayerCard({super.key});

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<TimingBloc, TimingState>(
      builder: (context, state) {
        if (state is! TimingLoaded) {
          return _shell(
            isDark: isDark,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 28.h),
              child: const Center(
                child: CircularProgressIndicator(
                  color: HomeTheme.highlight,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        final next = nextPrayerDetails(state.timing.data.timings);
        if (next == null) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locState) {
            final location = locState is LocationSuccess
                ? cityCountryFromPlacemark(locState.placemark)
                : '';

            return _shell(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (location.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18.sp,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (location.isNotEmpty) SizedBox(height: 10.h),
                  Text(
                    'Next Prayer: ${next.name} in ${formatPrayerCountdown(next.remaining)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: LinearProgressIndicator(
                      value: next.progress,
                      minHeight: 8.h,
                      backgroundColor: Colors.black.withValues(alpha: 0.25),
                      color: HomeTheme.highlight,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _shell({required bool isDark, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? HomeTheme.nextPrayerGreenDark : HomeTheme.nextPrayerGreen,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: kLightPrimary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
