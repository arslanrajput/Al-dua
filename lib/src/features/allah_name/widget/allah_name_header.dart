import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/allah_name_theme.dart';

class AllahNameHeader extends StatelessWidget {
  const AllahNameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: AllahNameTheme.headerBackground(context),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'Asma-ul-Husna',
            textAlign: TextAlign.center,
            style: AllahNameTheme.titleStyle(context),
          ),
          SizedBox(height: 10.h),
          Text(
            'Recite and reflect upon the most beautiful names of the Almighty.',
            textAlign: TextAlign.center,
            style: AllahNameTheme.subtitleStyle(context),
          ),
        ],
      ),
    );
  }
}
