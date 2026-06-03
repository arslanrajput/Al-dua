import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/model/prayer_notification_id.dart';
import '../../home/theme/home_theme.dart';
import '../../setting/theme/setting_theme.dart';
import '../theme/prayer_timing_theme.dart';
import 'exact_alarm_permission_card.dart';

class AzanNotificationSettings extends StatelessWidget {
  const AzanNotificationSettings({
    super.key,
    required this.onChanged,
  });

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NOTIFICATIONS',
          style: PrayerTimingTheme.sectionLabelStyle(context),
        ),
        SizedBox(height: 8.h),
        Text(
          'Azan reminders',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: HomeTheme.primaryText(context),
              ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Enable alerts for each prayer. Times use your GPS location.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: HomeTheme.mutedText(context),
                height: 1.35,
              ),
        ),
        SizedBox(height: 14.h),
        ExactAlarmPermissionCard(onPermissionChanged: onChanged),
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, globalState) {
            if (globalState.status != PermissionStatus.granted) {
              return _buildPermissionBanner(context);
            }
            return const SizedBox.shrink();
          },
        ),
        BlocBuilder<PrayerNotificationBloc, PrayerNotificationState>(
          builder: (context, notifState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              decoration: BoxDecoration(
                color: SettingTheme.surfaceCard(context),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: SettingTheme.cardShadow(context),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE8EEF4),
                ),
              ),
              child: Column(
                  children: [
                    for (var i = 0;
                        i < PrayerNotificationId.values.length;
                        i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          indent: 66.w,
                          endIndent: 14.w,
                          color: SettingTheme.divider(context),
                        ),
                      _PrayerNotificationRow(
                        prayer: PrayerNotificationId.values[i],
                        enabled: notifState.isEnabled(
                          PrayerNotificationId.values[i],
                        ),
                        onChanged: (value) {
                          BlocProvider.of<PrayerNotificationBloc>(context).add(
                            SetPrayerNotificationEnabled(
                              PrayerNotificationId.values[i],
                              value,
                            ),
                          );
                          onChanged();
                        },
                      ),
                    ],
                    Divider(
                      height: 1,
                      indent: 66.w,
                      endIndent: 14.w,
                      color: SettingTheme.divider(context),
                    ),
                    _AzanSoundRow(
                      enabled: notifState.azanSoundEnabled,
                      onChanged: (value) {
                        BlocProvider.of<PrayerNotificationBloc>(context).add(
                          SetAzanSoundEnabled(value),
                        );
                        onChanged();
                      },
                    ),
                  ],
                ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPermissionBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_off_outlined,
              color: Colors.orange.shade800, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Turn on notifications in your phone Settings to receive Azan alerts.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF5D4037),
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerNotificationRow extends StatelessWidget {
  const _PrayerNotificationRow({
    required this.prayer,
    required this.enabled,
    required this.onChanged,
  });

  final PrayerNotificationId prayer;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark
                  ? SettingTheme.iconTileBgDark
                  : SettingTheme.iconTileBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              _iconForPrayer(prayer),
              color: kBrandLogoGreen,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              prayer.prayerName,
              style: SettingTheme.tileTitleStyle(context),
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: kBrandLogoGreen,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD5DEE8),
          ),
        ],
      ),
    );
  }

  IconData _iconForPrayer(PrayerNotificationId prayer) {
    switch (prayer) {
      case PrayerNotificationId.fajr:
        return Icons.wb_twilight_rounded;
      case PrayerNotificationId.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerNotificationId.asr:
        return Icons.wb_cloudy_outlined;
      case PrayerNotificationId.maghrib:
        return Icons.wb_sunny_rounded;
      case PrayerNotificationId.isha:
        return Icons.nights_stay_outlined;
    }
  }
}

class _AzanSoundRow extends StatelessWidget {
  const _AzanSoundRow({
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark
                  ? SettingTheme.iconTileBgDark
                  : SettingTheme.iconTileBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.volume_up_rounded,
              color: kBrandLogoGreen,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Play Azan sound',
                  style: SettingTheme.tileTitleStyle(context),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Plays when a prayer notification fires',
                  style: SettingTheme.tileSubtitleStyle(context),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: kBrandLogoGreen,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD5DEE8),
          ),
        ],
      ),
    );
  }
}
