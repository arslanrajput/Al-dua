import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/location_display.dart';
import '../blocs/angle_bloc/angle_bloc.dart';
import '../controller/qibla_controller.dart';
import '../theme/qibla_theme.dart';
import 'compass.dart';
import 'qibla_info_card.dart';
import 'qibla_location_chip.dart';

class QiblaContent extends StatefulWidget {
  const QiblaContent({super.key, required this.qiblaBearing});

  final double qiblaBearing;

  @override
  State<QiblaContent> createState() => _QiblaContentState();
}

class _QiblaContentState extends State<QiblaContent> {
  late final AngleBloc _angleBloc;

  @override
  void initState() {
    super.initState();
    _angleBloc = AngleBloc(widget.qiblaBearing);
  }

  @override
  void dispose() {
    _angleBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _angleBloc,
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locState) {
          final location = locState is LocationSuccess
              ? cityCountryFromPlacemark(locState.placemark)
              : '';

          final distanceKm = locState is LocationSuccess
              ? distanceToKaabaKm(
                  locState.latitude,
                  locState.longitude,
                )
              : null;

          return BlocBuilder<AngleBloc, AngleState>(
            builder: (context, angleState) {
              final heading =
                  angleState is AngleLoaded ? angleState.angle : null;
              final facing = heading != null &&
                  isFacingQibla(heading, widget.qiblaBearing);
              final compassOk = angleState is AngleLoaded;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: Column(
                  children: [
                    Center(child: QiblaLocationChip(location: location)),
                    SizedBox(height: 20.h),
                    Text(
                      facing
                          ? 'You are facing the Qibla'
                          : 'Align your device with the Qibla',
                      textAlign: TextAlign.center,
                      style: QiblaTheme.headingStyle(context),
                    ),
                    SizedBox(height: 24.h),
                    const Compass(),
                    SizedBox(height: 24.h),
                    QiblaInfoCard(
                      distanceLabel: distanceKm != null
                          ? formatDistanceKm(distanceKm)
                          : '—',
                      directionLabel:
                          formatQiblaDirectionLabel(widget.qiblaBearing),
                      compassAvailable: compassOk,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
