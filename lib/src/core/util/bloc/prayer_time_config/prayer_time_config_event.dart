part of 'prayer_time_config_bloc.dart';

abstract class PrayerTimeConfigEvent extends Equatable {
  const PrayerTimeConfigEvent();
}

class SetPrayerTimeMethod extends PrayerTimeConfigEvent {
  final PrayerTimeMethod method;
  const SetPrayerTimeMethod(this.method);

  @override
  List<Object> get props => [method];
}

class SetMadhab extends PrayerTimeConfigEvent {
  final MadhabType madhab;
  const SetMadhab(this.madhab);

  @override
  List<Object> get props => [madhab];
}

class SetPrayerDayOffset extends PrayerTimeConfigEvent {
  final int offset;
  const SetPrayerDayOffset(this.offset);

  @override
  List<Object> get props => [offset];
}

class SetHijriAdjustmentDays extends PrayerTimeConfigEvent {
  final int offset;
  const SetHijriAdjustmentDays(this.offset);

  @override
  List<Object> get props => [offset];
}

class ResetPrayerTimeConfig extends PrayerTimeConfigEvent {
  const ResetPrayerTimeConfig();

  @override
  List<Object> get props => [];
}

