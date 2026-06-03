import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../model/madhab_type.dart';

part 'prayer_time_config_event.dart';
part 'prayer_time_config_state.dart';

class PrayerTimeConfigBloc
    extends HydratedBloc<PrayerTimeConfigEvent, PrayerTimeConfigState> {
  PrayerTimeConfigBloc()
      : super(
          const PrayerTimeConfigState(
            method: PrayerTimeMethod.mwl,
            madhab: MadhabType.shafi,
            dayOffset: 0,
            hijriAdjustmentDays: 0,
          ),
        ) {
    on<PrayerTimeConfigEvent>((event, emit) async {
      if (event is SetPrayerTimeMethod) {
        emit(state.copyWith(method: event.method));
      } else if (event is SetMadhab) {
        emit(state.copyWith(madhab: event.madhab));
      } else if (event is SetPrayerDayOffset) {
        emit(state.copyWith(dayOffset: event.offset.clamp(0, 2)));
      } else if (event is SetHijriAdjustmentDays) {
        emit(state.copyWith(hijriAdjustmentDays: event.offset.clamp(0, 2)));
      } else if (event is ResetPrayerTimeConfig) {
        emit(const PrayerTimeConfigState(
          method: PrayerTimeMethod.mwl,
          madhab: MadhabType.shafi,
          dayOffset: 0,
          hijriAdjustmentDays: 0,
        ));
      }
    });
  }

  @override
  PrayerTimeConfigState? fromJson(Map<String, dynamic> json) {
    try {
      final methodId = int.tryParse(json['methodId']?.toString() ?? '');
      final madhabIndex = int.tryParse(json['madhabIndex']?.toString() ?? '');
      final schoolId = int.tryParse(json['schoolId']?.toString() ?? '');
      final dayOffset = int.tryParse(json['dayOffset']?.toString() ?? '') ?? 0;
      final hijriAdj =
          int.tryParse(json['hijriAdjustmentDays']?.toString() ?? '') ?? 0;

      final method = PrayerTimeMethodX.fromId(methodId) ?? PrayerTimeMethod.mwl;
      final madhab = MadhabTypeX.fromIndex(madhabIndex) ??
          MadhabTypeX.fromLegacySchoolId(schoolId) ??
          MadhabType.shafi;

      return PrayerTimeConfigState(
        method: method,
        madhab: madhab,
        dayOffset: dayOffset.clamp(0, 2),
        hijriAdjustmentDays: hijriAdj.clamp(0, 2),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PrayerTimeConfigState state) {
    try {
      return {
        'methodId': state.method.id,
        'madhabIndex': state.madhab.index,
        'dayOffset': state.dayOffset,
        'hijriAdjustmentDays': state.hijriAdjustmentDays,
      };
    } catch (_) {
      return null;
    }
  }
}

enum PrayerTimeMethod {
  mwl,
  isna,
  egyptian,
  makkah,
  karachi,
  tehran,
  jafari,
}

extension PrayerTimeMethodX on PrayerTimeMethod {
  int get id {
    switch (this) {
      case PrayerTimeMethod.mwl:
        return 3;
      case PrayerTimeMethod.isna:
        return 2;
      case PrayerTimeMethod.egyptian:
        return 5;
      case PrayerTimeMethod.makkah:
        return 4;
      case PrayerTimeMethod.karachi:
        return 1;
      case PrayerTimeMethod.tehran:
        return 7;
      case PrayerTimeMethod.jafari:
        return 0;
    }
  }

  String get label {
    switch (this) {
      case PrayerTimeMethod.mwl:
        return 'Muslim World League';
      case PrayerTimeMethod.isna:
        return 'ISNA';
      case PrayerTimeMethod.egyptian:
        return 'Egyptian';
      case PrayerTimeMethod.makkah:
        return 'Umm al-Qura (Makkah)';
      case PrayerTimeMethod.karachi:
        return 'Karachi';
      case PrayerTimeMethod.tehran:
        return 'Tehran';
      case PrayerTimeMethod.jafari:
        return 'Jafari';
    }
  }

  static PrayerTimeMethod? fromId(int? id) {
    if (id == null) return null;
    for (final method in PrayerTimeMethod.values) {
      if (method.id == id) return method;
    }
    return null;
  }
}

