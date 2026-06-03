import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/qibla_theme.dart';

class QiblaLocationChip extends StatelessWidget {
  const QiblaLocationChip({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    if (location.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: QiblaTheme.locationChipBg,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 16.sp,
            color: QiblaTheme.locationChipText,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              location,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: QiblaTheme.locationChipText,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
