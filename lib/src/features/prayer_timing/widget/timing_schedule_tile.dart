import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/util/constants.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/bloc/time_format/time_format_bloc.dart';
import '../../../core/util/controller/timing_controller.dart';
import '../../../core/util/model/prayer_notification_id.dart';
import '../../home/theme/home_theme.dart';
import '../theme/prayer_timing_theme.dart';

class TimingScheduleTile extends StatelessWidget {
  const TimingScheduleTile({
    super.key,
    required this.name,
    required this.time,
    required this.isActive,
    required this.enabled,
    required this.azanSoundEnabled,
    required this.onToggle,
  });

  final String name;
  final String time;
  final bool isActive;
  final bool enabled;
  final bool azanSoundEnabled;
  final ValueChanged<bool> onToggle;

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

  String get _alertLabel {
    if (!enabled) return 'Notification';
    return azanSoundEnabled ? 'Adhan' : 'Notification';
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
            Text(
              _alertLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Switch.adaptive(
              value: enabled,
              onChanged: onToggle,
              activeTrackColor: kLightPrimary.withValues(alpha: 0.45),
              activeThumbColor: kLightPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

void togglePrayerNotification(BuildContext context, String prayerName, bool value) {
  final prayer = PrayerNotificationId.fromPrayerName(prayerName);
  if (prayer == null) return;

  context.read<PrayerNotificationBloc>().add(
        SetPrayerNotificationEnabled(prayer, value),
      );

  final notificationStatus = context.read<NotificationBloc>().state.status;
  final prayerNotifications = context.read<PrayerNotificationBloc>().state;

  if (notificationStatus == PermissionStatus.granted) {
    context.read<TimingBloc>().add(
          ReschedulePrayerNotifications(
            notificationStatus,
            prayerNotifications,
          ),
        );
  }
}
