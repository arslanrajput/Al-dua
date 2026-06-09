import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../azan/azan_audio_service.dart';
import '../util/model/prayer_notification_id.dart';
import 'receive_notification.dart';

@pragma('vm:entry-point')
void onAzanNotificationBackground(NotificationResponse response) {
  WidgetsFlutterBinding.ensureInitialized();
  if (response.payload == 'azan_play') {
    AzanAudioService.instance.play();
  }
}

/// Handles local Azan / prayer-time notifications.
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  static const String _channelId = 'azan_prayer_channel_v2';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();

  factory NotificationService() => _notificationService;

  NotificationService._internal();

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  Future<void> init() async {
    await _configureLocalTimeZone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onAzanNotificationBackground,
    );

    await _createAndroidChannel();
    await checkNotification();
  }

  /// Whether Android will allow scheduling at the exact prayer minute.
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    try {
      return await _androidPlugin?.canScheduleExactNotifications() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Opens the system screen to allow "Alarms & reminders" / exact alarms.
  Future<void> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _androidPlugin?.requestExactAlarmsPermission();
    } catch (e) {
      log('openExactAlarmSettings: $e');
    }
    try {
      await Permission.scheduleExactAlarm.request();
    } catch (_) {}
  }

  /// Requests OS permissions and prepares the notification channel.
  Future<bool> ensureReady() async {
    if (Platform.isAndroid) {
      final notifGranted =
          await _androidPlugin?.requestNotificationsPermission() ?? false;
      await openExactAlarmSettings();
      await _createAndroidChannel();
      if (!notifGranted) {
        final status = await Permission.notification.status;
        return status.isGranted;
      }
      return true;
    }

    if (Platform.isIOS) {
      final iosPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
      return granted;
    }

    return true;
  }

  Future<void> _createAndroidChannel() async {
    if (!Platform.isAndroid) return;

    const channel = AndroidNotificationChannel(
      _channelId,
      'Azan Prayer Times',
      description: 'Daily prayer time reminders with Azan',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: null,
    );

    await _androidPlugin?.createNotificationChannel(channel);
  }

  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload == 'azan_play') {
      AzanAudioService.instance.play();
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    } on MissingPluginException catch (e) {
      log('FlutterTimezone unavailable, using device offset fallback: $e');
      _setLocalTimeZoneFromDeviceOffset();
    } catch (e) {
      log('Timezone setup failed, using UTC: $e');
      tz.setLocalLocation(tz.UTC);
    }
  }

  void _setLocalTimeZoneFromDeviceOffset() {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    final name = hours >= 0 ? 'Etc/GMT-${hours.abs()}' : 'Etc/GMT+${hours.abs()}';
    try {
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelPrayerNotifications() async {
    for (final prayer in PrayerNotificationId.values) {
      await flutterLocalNotificationsPlugin.cancel(id: prayer.id);
    }
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    required bool playAzanSound,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      'Azan Prayer Times',
      channelDescription: 'Notifications when it is time for prayer.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: playAzanSound,
      enableVibration: true,
      ticker: 'Azan Time',
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: playAzanSound,
      presentBadge: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final useExact = await canScheduleExactAlarms();
    final scheduleMode = useExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTime,
        notificationDetails: details,
        androidScheduleMode: scheduleMode,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: playAzanSound ? 'azan_play' : 'azan_silent',
      );
      log(
        'Scheduled prayer $id at $scheduledTime '
        '(${useExact ? "exact" : "inexact"} alarm)',
      );
    } catch (e, st) {
      log('Exact schedule failed for $id, retrying inexact: $e');
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledTime,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: playAzanSound ? 'azan_play' : 'azan_silent',
        );
        log('Scheduled prayer $id (inexact fallback)');
      } catch (e2, st2) {
        log('Failed to schedule prayer $id: $e2', stackTrace: st2);
      }
    }
  }

  Future<void> checkNotification() async {
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    log('Pending notifications: ${pending.length}');
    for (final n in pending) {
      log('  id=${n.id} title=${n.title} body=${n.body}');
    }
  }
}
