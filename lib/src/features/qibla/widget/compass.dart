// ignore_for_file: unnecessary_type_check

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';

import '../../home/theme/home_theme.dart';
import '../blocs/angle_bloc/angle_bloc.dart';
import '../controller/qibla_controller.dart';

class Compass extends StatefulWidget {
  const Compass();

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  final CompassSensorReader _sensorReader = CompassSensorReader();
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<MagnetometerEvent>? _magSubscription;

  @override
  void initState() {
    super.initState();
    final interval = Duration.microsecondsPerSecond ~/ 60;
    motionSensors.accelerometerUpdateInterval = interval;
    motionSensors.magnetometerUpdateInterval = interval;

    getMagnetometerAvailability().then((isSensorAvailable) {
      if (!mounted) return;
      if (!isSensorAvailable) {
        context.read<AngleBloc>().add(NotifyFailure());
        return;
      }

      _accelSubscription = motionSensors.accelerometer.listen((event) {
        _sensorReader.updateAccelerometer(event);
        _publishHeading();
      });
      _magSubscription = motionSensors.magnetometer.listen((event) {
        _sensorReader.updateMagnetometer(event);
        _publishHeading();
      });
    });
  }

  void _publishHeading() {
    if (!mounted) return;
    final heading = _sensorReader.readHeadingDegrees();
    if (heading == null) return;
    context.read<AngleBloc>().add(SetCompassHeading(heading));
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _magSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AngleBloc, AngleState>(
      builder: (context, state) {
        if (state is AngleLoaded) {
          final size = 0.78.sw;
          return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size * 1.06,
                    height: size * 1.06,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: HomeTheme.highlight.withValues(alpha: 0.18),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                  Transform.rotate(
                    angle: state.radian,
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/qiblat_icon/svg/al_dua_compass_dial.svg',
                            width: size,
                            height: size,
                            fit: BoxFit.contain,
                          ),
                          Transform.rotate(
                            angle: state.qiblaDirection,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/images/qiblat_icon/svg/al_dua_compass_needle.svg',
                              height: size * 0.56,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is AngleFailed) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LottieBuilder.asset(
                  'assets/images/error/lottie_json/lost_compass.json',
                  width: 0.8.sw,
                ),
                const Text(
                  'Unfortunately, compass for kiblah direction cannot be displayed '
                  'as this phone does not have the magnetometer sensor.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
