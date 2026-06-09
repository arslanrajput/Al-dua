import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../notification/notification_service.dart';
import '../util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../util/model/prayer_notification_id.dart';
import '../util/prayer_time_parser.dart';

/// Schedules exact local Azan notifications for enabled prayers.
class AzanNotificationScheduler {
  static Future<void> reschedule({
    required List<Map<String, String>> timingsList,
    required PrayerNotificationState settings,
    required PermissionStatus globalNotificationStatus,
  }) async {
    await NotificationService().cancelPrayerNotifications();

    if (globalNotificationStatus != PermissionStatus.granted) {
      log('AzanScheduler: skipped — notifications not granted in app');
      return;
    }

    final ready = await NotificationService().ensureReady();
    if (!ready) {
      log('AzanScheduler: skipped — OS notification permission denied');
      return;
    }

    final entries = buildPrayerNotificationEntries(timingsList, settings);
    log('AzanScheduler: scheduling ${entries.length} prayer alarms');

    for (final entry in entries) {
      await NotificationService().schedulePrayerNotification(
        id: entry.id,
        title: entry.title,
        body: entry.body,
        scheduledTime: entry.scheduledTime,
        playAzanSound: settings.azanSoundEnabled,
      );
    }

    await NotificationService().checkNotification();
  }

  static List<_PrayerScheduleEntry> buildPrayerNotificationEntries(
    List<Map<String, String>> timingsList,
    PrayerNotificationState settings,
  ) {
    final List<_PrayerScheduleEntry> notificationList = [];
    final now = tz.TZDateTime.now(tz.local);

    for (final timing in timingsList) {
      final prayerName = timing.entries.first.key;
      final timeStr = timing.entries.first.value;
      final prayerId = PrayerNotificationId.fromPrayerName(prayerName);
      if (prayerId == null) continue;
      if (!settings.isEnabled(prayerId)) continue;

      final hour = PrayerTimeParser.parseHour(timeStr);
      final minute = PrayerTimeParser.parseMinute(timeStr);
      if (hour == null || minute == null) {
        log('AzanScheduler: invalid time for $prayerName: $timeStr');
        continue;
      }

      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (!scheduled.isAfter(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      notificationList.add(
        _PrayerScheduleEntry(
          id: prayerId.id,
          title: 'Azan Time',
          body: "It's time for $prayerName",
          scheduledTime: scheduled,
        ),
      );
    }

    return notificationList;
  }
}

class _PrayerScheduleEntry {
  const _PrayerScheduleEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
  });

  final int id;
  final String title;
  final String body;
  final tz.TZDateTime scheduledTime;
}
