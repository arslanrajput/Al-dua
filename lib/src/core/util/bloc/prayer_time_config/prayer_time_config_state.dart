part of 'prayer_time_config_bloc.dart';

class PrayerTimeConfigState extends Equatable {
  final PrayerTimeMethod method;
  final MadhabType madhab;
  final int dayOffset;
  final int hijriAdjustmentDays;

  const PrayerTimeConfigState({
    required this.method,
    required this.madhab,
    required this.dayOffset,
    required this.hijriAdjustmentDays,
  });

  PrayerTimeConfigState copyWith({
    PrayerTimeMethod? method,
    MadhabType? madhab,
    int? dayOffset,
    int? hijriAdjustmentDays,
  }) {
    return PrayerTimeConfigState(
      method: method ?? this.method,
      madhab: madhab ?? this.madhab,
      dayOffset: dayOffset ?? this.dayOffset,
      hijriAdjustmentDays: hijriAdjustmentDays ?? this.hijriAdjustmentDays,
    );
  }

  @override
  List<Object> get props => [
        method,
        madhab,
        dayOffset,
        hijriAdjustmentDays,
      ];
}

