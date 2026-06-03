import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/theme/home_theme.dart';
import '../theme/qibla_theme.dart';

class QiblaInfoCard extends StatelessWidget {
  const QiblaInfoCard({
    super.key,
    required this.distanceLabel,
    required this.directionLabel,
    this.compassAvailable = true,
  });

  final String distanceLabel;
  final String directionLabel;
  final bool compassAvailable;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 14.h),
      decoration: BoxDecoration(
        color: isDark ? HomeTheme.darkCardElevated : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _StatColumn(
                    label: 'DISTANCE',
                    value: distanceLabel,
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : const Color(0xFFE0E8E4),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'DIRECTION',
                    value: directionLabel,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : const Color(0xFFE8EEF0),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_rounded,
                size: 16.sp,
                color: HomeTheme.highlight,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  compassAvailable
                      ? 'Compass calibrated for your location'
                      : 'Location set — compass sensor unavailable',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: HomeTheme.mutedText(context),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: QiblaTheme.statLabelStyle(context)),
        SizedBox(height: 6.h),
        Text(
          value,
          textAlign: TextAlign.center,
          style: QiblaTheme.statValueStyle(context),
        ),
      ],
    );
  }
}
