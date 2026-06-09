part of 'timing_bloc.dart';

abstract class TimingEvent extends Equatable {
  const TimingEvent();
}

class RequestTiming extends TimingEvent {
  final LocationState locationState;

  final PermissionStatus notificationEnabled;
  final PrayerNotificationState prayerNotificationSettings;
  final int method;
  final int school;
  final int dayOffset;
  final int hijriAdjustmentDays;

  const RequestTiming(
    this.notificationEnabled,
    this.prayerNotificationSettings,
    this.locationState,
    this.method,
    this.school,
    this.dayOffset,
    this.hijriAdjustmentDays,
  );

  @override
  List<Object> get props => [
        notificationEnabled,
        prayerNotificationSettings,
        locationState,
        method,
        school,
        dayOffset,
        hijriAdjustmentDays,
      ];
}

class RequestTimingForTomorrow extends TimingEvent {
  final LocationState locationState;
  final PermissionStatus notificationEnabled;
  final PrayerNotificationState prayerNotificationSettings;
  final int method;
  final int school;
  final int dayOffset;
  final int hijriAdjustmentDays;

  const RequestTimingForTomorrow(
    this.notificationEnabled,
    this.prayerNotificationSettings,
    this.locationState,
    this.method,
    this.school,
    this.dayOffset,
    this.hijriAdjustmentDays,
  );

  @override
  List<Object> get props => [
        notificationEnabled,
        prayerNotificationSettings,
        locationState,
        method,
        school,
        dayOffset,
        hijriAdjustmentDays,
      ];
}

class ReschedulePrayerNotifications extends TimingEvent {
  final PermissionStatus notificationEnabled;
  final PrayerNotificationState prayerNotificationSettings;

  const ReschedulePrayerNotifications(
    this.notificationEnabled,
    this.prayerNotificationSettings,
  );

  @override
  List<Object> get props => [
        notificationEnabled,
        prayerNotificationSettings,
      ];
}

class UpdateTiming extends TimingEvent {
  @override
  List<Object> get props => [];
}

class PushNotification extends TimingEvent {
  @override
  List<Object> get props => [];
}

class CancelNotification extends TimingEvent {
  @override
  List<Object> get props => [];
}
