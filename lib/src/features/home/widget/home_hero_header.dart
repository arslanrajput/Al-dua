import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:al_dua/src/core/util/controller/date_controller.dart';

import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/theme/theme_bloc.dart';
import '../theme/home_theme.dart';
import 'upcoming_prayer_text.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return SvgPicture.asset(
              'assets/images/home_icon/svg/background.svg',
              fit: BoxFit.cover,
            );
          },
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.35),
                Colors.black.withValues(alpha: 0.55),
              ],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<PrayerTimeConfigBloc, PrayerTimeConfigState>(
                  builder: (context, prayerConfig) {
                    return Text(
                      getIslamicDate(
                        adjustmentDays: prayerConfig.hijriAdjustmentDays,
                      ),
                      style: TextStyle(
                        color: HomeTheme.accent,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                SizedBox(height: 4.h),
                Text(
                  getTodayDate(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                const _LiveClock(),
                SizedBox(height: 10.h),
                const UpcomingPrayerText(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('hh:mm a').format(_now),
      style: TextStyle(
        color: Colors.white,
        fontSize: 36.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        height: 1.1,
      ),
    );
  }
}
