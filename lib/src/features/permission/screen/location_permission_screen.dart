import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../routes/routes.dart';
import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/constants.dart';
import '../widget/permission_page_layout.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  Future<void> _goToHome(BuildContext context) async {
    if (!context.mounted) return;
    await Navigator.of(context).pushReplacementNamed(RouteGenerator.tabScreen);
  }

  @override
  Widget build(BuildContext context) {
    return PermissionPageLayout(
      icon: Icons.location_on_rounded,
      lottieAsset: 'assets/images/permission/lottie_json/location_permission.json',
      title: 'Location for prayer times',
      description:
          '$kAppDisplayName uses your location to show accurate prayer times '
          'and Qibla direction for your city.',
      bullets: const [
        'Daily Fajr, Dhuhr, Asr, Maghrib & Isha times for where you are',
        'Correct Asr time for your selected madhab',
        'Qibla compass aligned to your position',
      ],
      primaryButtonText: 'Allow location',
      onPrimaryPressed: () async {
        final status = await Permission.location.request();
        if (!context.mounted) return;
        if (status.isGranted) {
          BlocProvider.of<LocationBloc>(context).add(InitLocation());
        }
        await _goToHome(context);
      },
      secondaryButtonText: 'Not now',
      onSecondaryPressed: () => _goToHome(context),
    );
  }
}
