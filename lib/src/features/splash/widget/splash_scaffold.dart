import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../routes/routes.dart';
import '../../../core/util/bloc/database/database_bloc.dart';
import '../../../core/util/constants.dart';
import '../../utils/app_logo.dart';

class SplashScaffold extends StatelessWidget {
  const SplashScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseBloc, DatabaseState>(
      listener: (context, state) async {
        await Future.delayed(const Duration(milliseconds: 750));
        if (state is DatabaseLoaded) {
          final locationPermission = await Permission.location.status;

          if (!locationPermission.isGranted) {
            Navigator.of(context)
                .pushReplacementNamed(RouteGenerator.locationPermission);
          } else {
            Navigator.of(context).pushReplacementNamed(RouteGenerator.tabScreen);
          }
        } else if (state is DatabaseFailed) {
          Navigator.of(context)
              .pushReplacementNamed(RouteGenerator.databaseError);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: kBrandLogoGreen,
          body: Center(
            child: AppLogo(
              size: 200.w,
              borderRadius: BorderRadius.circular(28.r),
            ),
          ),
        ),
      ),
    );
  }
}
