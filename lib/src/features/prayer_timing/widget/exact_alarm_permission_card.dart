import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/notification/notification_service.dart';
import '../../../core/util/constants.dart';

/// Prompts user to allow exact alarms so prayer notifications fire on time.
class ExactAlarmPermissionCard extends StatefulWidget {
  const ExactAlarmPermissionCard({super.key, this.onPermissionChanged});

  final VoidCallback? onPermissionChanged;

  @override
  State<ExactAlarmPermissionCard> createState() =>
      _ExactAlarmPermissionCardState();
}

class _ExactAlarmPermissionCardState extends State<ExactAlarmPermissionCard> {
  bool _loading = true;
  bool _exactAlarmsAllowed = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (!Platform.isAndroid) {
      setState(() {
        _loading = false;
        _exactAlarmsAllowed = true;
      });
      return;
    }
    final allowed = await NotificationService().canScheduleExactAlarms();
    if (mounted) {
      setState(() {
        _loading = false;
        _exactAlarmsAllowed = allowed;
      });
    }
  }

  Future<void> _openExactAlarmSettings() async {
    await NotificationService().openExactAlarmSettings();
    await Future.delayed(const Duration(milliseconds: 500));
    await _refresh();
    widget.onPermissionChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid || _loading || _exactAlarmsAllowed) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.alarm_rounded,
                color: theme.colorScheme.error,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Allow alarms for on-time Azan',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Android needs permission to ring exactly at prayer time. '
            'If you do not see "Alarms & reminders", tap the button below — '
            'it opens the correct screen for your phone.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 6.h),
          Text(
            'Manual path: Settings → Apps → $kAppDisplayName → '
            'Permissions → Alarms & reminders (or Other permissions).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _openExactAlarmSettings,
                  icon: const Icon(Icons.settings_rounded, size: 18),
                  label: const Text('Open alarm settings'),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: () async {
                  await openAppSettings();
                  await _refresh();
                  widget.onPermissionChanged?.call();
                },
                child: const Text('App settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
