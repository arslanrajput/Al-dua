import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../model/prayer_notification_id.dart';

part 'prayer_notification_event.dart';
part 'prayer_notification_state.dart';

class PrayerNotificationBloc
    extends HydratedBloc<PrayerNotificationEvent, PrayerNotificationState> {
  PrayerNotificationBloc() : super(const PrayerNotificationState()) {
    on<PrayerNotificationEvent>((event, emit) {
      if (event is SetPrayerNotificationEnabled) {
        emit(state.copyWithEnabled(event.prayer, event.enabled));
      } else if (event is SetAzanSoundEnabled) {
        emit(state.copyWith(azanSoundEnabled: event.enabled));
      } else if (event is ResetPrayerNotifications) {
        emit(const PrayerNotificationState());
      }
    });
  }

  @override
  PrayerNotificationState? fromJson(Map<String, dynamic> json) {
    try {
      return PrayerNotificationState(
        fajrEnabled: json['fajrEnabled'] as bool? ?? true,
        dhuhrEnabled: json['dhuhrEnabled'] as bool? ?? true,
        asrEnabled: json['asrEnabled'] as bool? ?? true,
        maghribEnabled: json['maghribEnabled'] as bool? ?? true,
        ishaEnabled: json['ishaEnabled'] as bool? ?? true,
        azanSoundEnabled: json['azanSoundEnabled'] as bool? ?? true,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PrayerNotificationState state) {
    return {
      'fajrEnabled': state.fajrEnabled,
      'dhuhrEnabled': state.dhuhrEnabled,
      'asrEnabled': state.asrEnabled,
      'maghribEnabled': state.maghribEnabled,
      'ishaEnabled': state.ishaEnabled,
      'azanSoundEnabled': state.azanSoundEnabled,
    };
  }
}
