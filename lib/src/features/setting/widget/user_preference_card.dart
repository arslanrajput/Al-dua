import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/util/bloc/notification/notification_bloc.dart';
import '../../../core/util/bloc/theme/theme_bloc.dart';
import '../../../core/util/bloc/time_format/time_format_bloc.dart';
import '../controller/setting_controller.dart';
import '../theme/setting_theme.dart';
import 'change_format_switch.dart';
import 'change_notification_switch.dart';
import 'change_theme_switch.dart';
import 'preference_row.dart';

class UserPreferenceCard extends StatelessWidget {
  const UserPreferenceCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Preferences',
            style: SettingTheme.sectionTitleStyle(context),
          ),
          SizedBox(height: 12.h),
          Material(
            color: SettingTheme.surfaceCard(context),
            borderRadius: BorderRadius.circular(12.r),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: SettingTheme.cardShadow(context),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE8EEF4),
                ),
              ),
              child: Column(
                children: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      final isLight =
                          state.currentTheme.brightness == Brightness.light;
                      return PreferenceRow(
                        iconPath: 'assets/images/setting_icon/svg/sun.svg',
                        title: 'Theme',
                        subtitle: isLight
                            ? 'Current: Light Mode'
                            : 'Current: Dark Mode',
                        trailing: ChangeThemeSwitch(
                          value: !isLight,
                          onChanged: (_) {
                            BlocProvider.of<ThemeBloc>(context).add(
                              ToggleTheme(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  BlocBuilder<TimeFormatBloc, TimeFormatState>(
                    builder: (context, state) {
                      return PreferenceRow(
                        iconPath: 'assets/images/home_icon/svg/fajr.svg',
                        title: 'Time Format',
                        subtitle: state.is24 ? '24-hour format' : '12-hour format',
                        trailing: ChangeFormatSwitch(
                          value: state.is24,
                          onChanged: (_) {
                            BlocProvider.of<TimeFormatBloc>(context).add(
                              ToggleFormat(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      return PreferenceRow(
                        iconPath:
                            'assets/images/setting_icon/svg/notification_outlined_enabled.svg',
                        title: 'Notifications',
                        showDivider: false,
                        trailing: ChangeNotificationSwitch(
                          value: state.status == PermissionStatus.granted,
                          onChanged: (_) {
                            notificationSwitchOnToggle(state, context);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
