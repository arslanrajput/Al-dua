import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/notification/notification_service.dart';
import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/model/madhab_type.dart';
import '../../../core/util/model/prayer_notification_id.dart';
import '../../utils/bottom_sheet_select.dart';
import '../widget/exact_alarm_permission_card.dart';
import '../widget/madhab_selection_card.dart';

class PrayerTimeSettingsScreen extends StatelessWidget {
  const PrayerTimeSettingsScreen({super.key});

  /// Fetches prayer times. Pass overrides when bloc state is not updated yet
  /// (e.g. right after [SetMadhab] in the same frame).
  void _refreshTimings(
    BuildContext context, {
    MadhabType? madhab,
    PrayerTimeMethod? method,
    int? dayOffset,
    int? hijriAdjustmentDays,
  }) {
    final locationState = BlocProvider.of<LocationBloc>(context).state;
    if (locationState is! LocationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location is required. Enable GPS and try again from the home screen.',
          ),
        ),
      );
      return;
    }

    final notificationStatus =
        BlocProvider.of<NotificationBloc>(context).state.status;
    final prayerNotifications =
        BlocProvider.of<PrayerNotificationBloc>(context).state;
    final config = BlocProvider.of<PrayerTimeConfigBloc>(context).state;

    final effectiveMadhab = madhab ?? config.madhab;
    final effectiveMethod = method ?? config.method;

    BlocProvider.of<TimingBloc>(context).add(
      RequestTiming(
        notificationStatus,
        prayerNotifications,
        locationState,
        effectiveMethod.id,
        effectiveMadhab.schoolId,
        dayOffset ?? config.dayOffset,
        hijriAdjustmentDays ?? config.hijriAdjustmentDays,
      ),
    );
  }

  Future<void> _rescheduleOnly(BuildContext context) async {
    BlocProvider.of<NotificationBloc>(context)
        .add(SyncNotificationPermission());
    await Future.delayed(const Duration(milliseconds: 200));

    final notificationStatus =
        BlocProvider.of<NotificationBloc>(context).state.status;
    final prayerNotifications =
        BlocProvider.of<PrayerNotificationBloc>(context).state;

    if (notificationStatus == PermissionStatus.granted) {
      await NotificationService().ensureReady();
    }

    BlocProvider.of<TimingBloc>(context).add(
      ReschedulePrayerNotifications(
        notificationStatus,
        prayerNotifications,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimingBloc, TimingState>(
      listenWhen: (prev, curr) =>
          prev is TimingLoading && curr is TimingLoaded,
      listener: (context, state) {
        final madhab =
            BlocProvider.of<PrayerTimeConfigBloc>(context).state.madhab;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Prayer times updated (${madhab.label} — Asr uses this madhab)',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Prayer time settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: kPagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'Madhab',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Hanafi uses a later Asr time. Shafi\'i, Maliki, and Hanbali '
                  'share the same Asr calculation on this API — only Hanafi vs '
                  'others changes times.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                SizedBox(height: 8.h),
                BlocBuilder<PrayerTimeConfigBloc, PrayerTimeConfigState>(
                  builder: (context, state) {
                    return Column(
                      children: MadhabType.values.map((madhab) {
                        return MadhabSelectionCard(
                          madhab: madhab,
                          selected: state.madhab == madhab,
                          onTap: () {
                            if (state.madhab == madhab) return;
                            BlocProvider.of<PrayerTimeConfigBloc>(context)
                                .add(SetMadhab(madhab));
                            _refreshTimings(context, madhab: madhab);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const Divider(),
                BlocBuilder<PrayerTimeConfigBloc, PrayerTimeConfigState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        BottomSheetSelect<PrayerTimeMethod>(
                          label: 'Calculation method',
                          value: state.method,
                          options: PrayerTimeMethod.values,
                          optionLabelBuilder: (m) => m.label,
                          onChanged: (method) {
                            BlocProvider.of<PrayerTimeConfigBloc>(context)
                                .add(SetPrayerTimeMethod(method));
                            _refreshTimings(context, method: method);
                          },
                        ),
                        const Divider(),
                        _StepSettingRow(
                          label: 'Prayer day offset',
                          value: state.dayOffset,
                          min: 0,
                          max: 2,
                          onChanged: (value) {
                            BlocProvider.of<PrayerTimeConfigBloc>(context)
                                .add(SetPrayerDayOffset(value));
                            _refreshTimings(context, dayOffset: value);
                          },
                        ),
                        const Divider(),
                        _StepSettingRow(
                          label: 'Hijri date adjustment',
                          value: state.hijriAdjustmentDays,
                          min: 0,
                          max: 2,
                          onChanged: (value) {
                            BlocProvider.of<PrayerTimeConfigBloc>(context)
                                .add(SetHijriAdjustmentDays(value));
                            _refreshTimings(
                              context,
                              hijriAdjustmentDays: value,
                            );
                          },
                        ),
                        const Divider(),
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              BlocProvider.of<PrayerTimeConfigBloc>(context)
                                  .add(const ResetPrayerTimeConfig());
                              _refreshTimings(context);
                            },
                            child: const Text('Reset to defaults'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8.h),
                Text(
                  'Azan notifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Enable reminders for each prayer. Times use your GPS location.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 8.h),
                ExactAlarmPermissionCard(
                  onPermissionChanged: () => _rescheduleOnly(context),
                ),
                BlocBuilder<PrayerNotificationBloc, PrayerNotificationState>(
                  builder: (context, notifState) {
                    return Column(
                      children: [
                        for (final prayer in PrayerNotificationId.values)
                          SwitchListTile(
                            title: Text(prayer.prayerName),
                            value: notifState.isEnabled(prayer),
                            onChanged: (value) {
                              BlocProvider.of<PrayerNotificationBloc>(context)
                                  .add(SetPrayerNotificationEnabled(
                                prayer,
                                value,
                              ));
                              _rescheduleOnly(context);
                            },
                          ),
                        const Divider(),
                        SwitchListTile(
                          title: const Text('Play Azan sound'),
                          subtitle: const Text(
                            'Plays Azan when a prayer notification fires',
                          ),
                          value: notifState.azanSoundEnabled,
                          onChanged: (value) {
                            BlocProvider.of<PrayerNotificationBloc>(context)
                                .add(SetAzanSoundEnabled(value));
                            _rescheduleOnly(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, globalState) {
                    if (globalState.status != PermissionStatus.granted) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                        child: Text(
                          'Turn on notifications in Settings to receive Azan alerts.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      );
                    }
                    return SizedBox(height: 16.h);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

class _StepSettingRow extends StatelessWidget {
  const _StepSettingRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrement = value > min;
    final canIncrement = value < max;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
          IconButton(
            onPressed: canDecrement ? () => onChanged(value - 1) : null,
            icon: Icon(Icons.remove, color: theme.primaryColor),
          ),
          Text(
            value.toString(),
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: canIncrement ? () => onChanged(value + 1) : null,
            icon: Icon(Icons.add, color: theme.primaryColor),
          ),
        ],
      ),
    );
  }
}
