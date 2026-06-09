import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../routes/routes.dart';
import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/theme.dart';
import '../../error/widget/failure_widget.dart';
import '../../home/theme/home_theme.dart';
import '../../utils/loading_widget.dart';
import '../theme/prayer_timing_theme.dart';
import 'success_widget.dart';

class TimingScreenScaffold extends StatelessWidget {
  const TimingScreenScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrayerTimingTheme.screenBg(context),
      appBar: AppBar(
        backgroundColor: PrayerTimingTheme.screenBg(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Prayer Timing',
          style: appBarTitleTextStyle(
            color: HomeTheme.primaryText(context),
            fontSize: 20.sp,
          ),
        ),
        iconTheme: IconThemeData(color: HomeTheme.primaryText(context)),
        actions: [
          IconButton(
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
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: BlocBuilder<TimingBloc, TimingState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: kAnimationDuration,
            reverseDuration: Duration.zero,
            switchInCurve: kAnimationCurve,
            child: (state is TimingLoading)
                ? const LoadingWidget()
                : (state is TimingLoaded)
                    ? SuccessWidget(state.timing)
                    : (state is TimingFailed)
                        ? FailureWidget(
                            state.failure,
                            () {
                              BlocProvider.of<LocationBloc>(context).add(
                                InitLocation(),
                              );
                            },
                            withAppbar: false,
                          )
                        : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
