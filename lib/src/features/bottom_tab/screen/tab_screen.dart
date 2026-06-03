import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/util/bloc/location/location_bloc.dart';
import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../../../core/util/controller/notification_controller.dart';
import '../../utils/loading_widget.dart';
import '../widget/tab_scaffold.dart';

class TabScreen extends StatefulWidget {
  const TabScreen();

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    configureDidReceiveLocalNotificationSubject(context);
    configureSelectNotificationSubject(context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncAndScheduleNotifications();
    });
    super.initState();
  }

  void _syncAndScheduleNotifications() {
    BlocProvider.of<NotificationBloc>(context)
        .add(SyncNotificationPermission());

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final notif = BlocProvider.of<NotificationBloc>(context).state.status;
      final prayerNotif =
          BlocProvider.of<PrayerNotificationBloc>(context).state;
      if (notif == PermissionStatus.granted) {
        BlocProvider.of<TimingBloc>(context).add(
          ReschedulePrayerNotifications(notif, prayerNotif),
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        _syncAndScheduleNotifications();
        BlocProvider.of<TimingBloc>(context).add(UpdateTiming());
      });
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    final locationState = BlocProvider.of<LocationBloc>(context).state;
    if (locationState is! LocationSuccess &&
        locationState is! LocationLoading) {
      BlocProvider.of<LocationBloc>(context).add(InitLocation());
    }

    super.didChangeDependencies();
  }

  void _onLocationReady(BuildContext context) {
    final prayerConfig = BlocProvider.of<PrayerTimeConfigBloc>(context).state;
    BlocProvider.of<TimingBloc>(context).add(
      RequestTiming(
        BlocProvider.of<NotificationBloc>(context).state.status,
        BlocProvider.of<PrayerNotificationBloc>(context).state,
        BlocProvider.of<LocationBloc>(context).state,
        prayerConfig.method.id,
        prayerConfig.madhab.schoolId,
        prayerConfig.dayOffset,
        prayerConfig.hijriAdjustmentDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LocationBloc, LocationState>(
          listenWhen: (prev, curr) =>
              curr is LocationSuccess && prev is! LocationSuccess,
          listener: (context, state) => _onLocationReady(context),
        ),
      ],
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return Scaffold(
              body: LoadingWidget(),
            );
          }
          return TabScaffold();
        },
      ),
    );
  }
}
