import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../routes/routes.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../theme/home_theme.dart';
import '../util/prayer_schedule_utils.dart';
import 'prayer_timing_widget.dart';

class KiblatCard extends StatelessWidget {
  const KiblatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Prayer Schedule',
                style: HomeTheme.scheduleTitleStyle(context),
              ),
            ),
            _PrayerSettingsButton(),
          ],
        ),
        SizedBox(height: 14.h),
        BlocBuilder<TimingBloc, TimingState>(
          builder: (context, state) {
            if (state is! TimingLoaded) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 28.h),
                child: Center(
                  child: SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: HomeTheme.accent.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              );
            }

            final t = state.timing.data.timings;
            final items = [
              _PrayerRow('Fajr', t.fajr),
              _PrayerRow('Dhuhr', t.dhuhr),
              _PrayerRow('Asr', t.asr),
              _PrayerRow('Maghrib', t.maghrib),
              _PrayerRow('Isha', t.isha),
            ];
            final next = nextPrayerDetails(t);
            final nextIdx = next?.index ?? 0;

            return Column(
              children: [
                for (int i = 0; i < items.length; i++)
                  PrayerTimeListTile(
                    name: items[i].name,
                    time: items[i].time,
                    isNext: i == nextIdx,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PrayerRow {
  final String name;
  final String time;
  const _PrayerRow(this.name, this.time);
}

class _PrayerSettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(RouteGenerator.prayerTimeSettings);
      },
      icon: SvgPicture.asset(
        'assets/images/navigation_icon/svg/setting_nfill.svg',
        width: 22.w,
        colorFilter: ColorFilter.mode(
          HomeTheme.mutedText(context),
          BlendMode.srcIn,
        ),
      ),
      tooltip: 'Prayer settings',
    );
  }
}
