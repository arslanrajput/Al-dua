import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/prayer_notification/prayer_notification_bloc.dart';
import '../../../core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import '../widget/notification_disabled_dialog.dart';

void notificationSwitchOnToggle(NotificationState state, BuildContext context) {
  if (state.status == PermissionStatus.permanentlyDenied) {
    showDialog(
      context: context,
      builder: (context) => NotificationDisabledDialog(),
    );
    return;
  }

  final wasGranted = state.status == PermissionStatus.granted;
  final wasRestricted = state.status == PermissionStatus.restricted;

  BlocProvider.of<NotificationBloc>(context).add(ToggleNotification());

  Future.delayed(const Duration(milliseconds: 400), () {
    if (!context.mounted) return;
    final newStatus =
        BlocProvider.of<NotificationBloc>(context).state.status;
    final prayerNotif =
        BlocProvider.of<PrayerNotificationBloc>(context).state;

    if (newStatus == PermissionStatus.granted &&
        (wasRestricted || !wasGranted)) {
      BlocProvider.of<TimingBloc>(context).add(
        ReschedulePrayerNotifications(newStatus, prayerNotif),
      );
    } else if (newStatus == PermissionStatus.restricted && wasGranted) {
      BlocProvider.of<TimingBloc>(context).add(CancelNotification());
    }
  });
}
