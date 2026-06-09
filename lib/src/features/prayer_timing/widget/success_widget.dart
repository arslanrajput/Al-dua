import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/location_display.dart';
import '../../../core/util/model/timing.dart';
import '../../home/theme/home_theme.dart';
import '../../home/util/prayer_schedule_utils.dart';
import '../theme/prayer_timing_theme.dart';
import 'timing_calendar_strip.dart';
import 'timing_next_prayer_card.dart';
import 'timing_quote_card.dart';
import 'timing_schedule_tile.dart';

class SuccessWidget extends StatefulWidget {
  const SuccessWidget(this.timing, {super.key});

  final Timing timing;

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  bool get _isToday => isSameCalendarDay(_selectedDate, DateTime.now());

  DateTime? _referenceTimeForNextPrayer() {
    final now = DateTime.now();
    if (_isToday) return now;
    if (_selectedDate.isAfter(DateTime(now.year, now.month, now.day))) {
      return DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
    }
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      23,
      59,
    );
  }

  void _requestTimingsForDate(DateTime date) {
    final locationState = context.read<LocationBloc>().state;
    if (locationState is! LocationSuccess) return;

    final config = context.read<PrayerTimeConfigBloc>().state;
    final extraDays = dayOffsetFromToday(date);

    context.read<TimingBloc>().add(
          RequestTiming(
            context.read<NotificationBloc>().state.status,
            const PrayerNotificationState(),
            locationState,
            config.method.id,
            config.madhab.schoolId,
            config.dayOffset + extraDays,
            config.hijriAdjustmentDays,
          ),
        );
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    _requestTimingsForDate(date);
  }

  void _shiftWeek(int delta) {
    final next = _selectedDate.add(Duration(days: delta * 7));
    _onDateSelected(next);
  }

  @override
  Widget build(BuildContext context) {
    final timings = widget.timing.data.timings;
    final next = nextPrayerDetails(
      timings,
      referenceTime: _referenceTimeForNextPrayer(),
    );
    final nextIdx = next?.index ?? 0;

    final prayers = [
      _PrayerItem('Fajr', timings.fajr),
      _PrayerItem('Dhuhr', timings.dhuhr),
      _PrayerItem('Asr', timings.asr),
      _PrayerItem('Maghrib', timings.maghrib),
      _PrayerItem('Isha', timings.isha),
    ];

    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locState) {
        final location = locState is LocationSuccess
            ? cityCountryFromPlacemark(locState.placemark)
            : '';

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (next != null)
                TimingNextPrayerCard(
                  next: next,
                  viewingToday: _isToday,
                ),
              SizedBox(height: 20.h),
              TimingCalendarStrip(
                selectedDate: _selectedDate,
                onDateSelected: _onDateSelected,
                onPreviousWeek: () => _shiftWeek(-1),
                onNextWeek: () => _shiftWeek(1),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isToday ? "TODAY'S SCHEDULE" : 'SCHEDULE',
                      style: PrayerTimingTheme.sectionLabelStyle(context),
                    ),
                  ),
                  if (location.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.sp,
                          color: HomeTheme.mutedText(context),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: HomeTheme.mutedText(context),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              for (int i = 0; i < prayers.length; i++)
                TimingScheduleTile(
                  name: prayers[i].name,
                  time: prayers[i].time,
                  isActive: _isToday && i == nextIdx,
                ),
              SizedBox(height: 16.h),
              const TimingQuoteCard(),
            ],
          ),
        );
      },
    );
  }
}

class _PrayerItem {
  const _PrayerItem(this.name, this.time);

  final String name;
  final String time;
}
