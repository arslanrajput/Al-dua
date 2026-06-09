part of 'prayer_notification_bloc.dart';

class PrayerNotificationState extends Equatable {
  const PrayerNotificationState({
    this.fajrEnabled = true,
    this.dhuhrEnabled = true,
    this.asrEnabled = true,
    this.maghribEnabled = true,
    this.ishaEnabled = true,
    this.azanSoundEnabled = true,
  });

  final bool fajrEnabled;
  final bool dhuhrEnabled;
  final bool asrEnabled;
  final bool maghribEnabled;
  final bool ishaEnabled;
  final bool azanSoundEnabled;

  bool isEnabled(PrayerNotificationId prayer) {
    switch (prayer) {
      case PrayerNotificationId.fajr:
        return fajrEnabled;
      case PrayerNotificationId.dhuhr:
        return dhuhrEnabled;
      case PrayerNotificationId.asr:
        return asrEnabled;
      case PrayerNotificationId.maghrib:
        return maghribEnabled;
      case PrayerNotificationId.isha:
        return ishaEnabled;
    }
  }

  PrayerNotificationState copyWith({
    bool? fajrEnabled,
    bool? dhuhrEnabled,
    bool? asrEnabled,
    bool? maghribEnabled,
    bool? ishaEnabled,
    bool? azanSoundEnabled,
  }) {
    return PrayerNotificationState(
      fajrEnabled: fajrEnabled ?? this.fajrEnabled,
      dhuhrEnabled: dhuhrEnabled ?? this.dhuhrEnabled,
      asrEnabled: asrEnabled ?? this.asrEnabled,
      maghribEnabled: maghribEnabled ?? this.maghribEnabled,
      ishaEnabled: ishaEnabled ?? this.ishaEnabled,
      azanSoundEnabled: azanSoundEnabled ?? this.azanSoundEnabled,
    );
  }

  PrayerNotificationState copyWithEnabled(
    PrayerNotificationId prayer,
    bool enabled,
  ) {
    switch (prayer) {
      case PrayerNotificationId.fajr:
        return copyWith(fajrEnabled: enabled);
      case PrayerNotificationId.dhuhr:
        return copyWith(dhuhrEnabled: enabled);
      case PrayerNotificationId.asr:
        return copyWith(asrEnabled: enabled);
      case PrayerNotificationId.maghrib:
        return copyWith(maghribEnabled: enabled);
      case PrayerNotificationId.isha:
        return copyWith(ishaEnabled: enabled);
    }
  }

  @override
  List<Object> get props => [
        fajrEnabled,
        dhuhrEnabled,
        asrEnabled,
        maghribEnabled,
        ishaEnabled,
        azanSoundEnabled,
      ];
}
