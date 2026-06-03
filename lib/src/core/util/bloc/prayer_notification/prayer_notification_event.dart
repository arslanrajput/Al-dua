part of 'prayer_notification_bloc.dart';

abstract class PrayerNotificationEvent extends Equatable {
  const PrayerNotificationEvent();
}

class SetPrayerNotificationEnabled extends PrayerNotificationEvent {
  const SetPrayerNotificationEnabled(this.prayer, this.enabled);

  final PrayerNotificationId prayer;
  final bool enabled;

  @override
  List<Object> get props => [prayer, enabled];
}

class SetAzanSoundEnabled extends PrayerNotificationEvent {
  const SetAzanSoundEnabled(this.enabled);

  final bool enabled;

  @override
  List<Object> get props => [enabled];
}

class ResetPrayerNotifications extends PrayerNotificationEvent {
  const ResetPrayerNotifications();

  @override
  List<Object> get props => [];
}
