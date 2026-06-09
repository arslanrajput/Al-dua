import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/model/madhab_type.dart';
import '../../setting/theme/setting_theme.dart';
import '../../utils/bottom_sheet_select.dart';
import '../theme/prayer_timing_theme.dart';
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
      backgroundColor: PrayerTimingTheme.screenBg(context),
      appBar: AppBar(
        backgroundColor: PrayerTimingTheme.screenBg(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Prayer time settings',
          style: SettingTheme.appBarTitleStyle(context),
        ),
        iconTheme: IconThemeData(color: SettingTheme.primaryText(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: kPagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'CALCULATION',
                  style: PrayerTimingTheme.sectionLabelStyle(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Madhab',
                  style: SettingTheme.sectionTitleStyle(context),
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
                SizedBox(height: 24.h),
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
              style: SettingTheme.tileTitleStyle(context),
            ),
          ),
          IconButton(
            onPressed: canDecrement ? () => onChanged(value - 1) : null,
            icon: Icon(Icons.remove, color: kBrandLogoGreen),
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: SettingTheme.primaryText(context),
            ),
          ),
          IconButton(
            onPressed: canIncrement ? () => onChanged(value + 1) : null,
            icon: Icon(Icons.add, color: kBrandLogoGreen),
          ),
        ],
      ),
    );
  }
}
