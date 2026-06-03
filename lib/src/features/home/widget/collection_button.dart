import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/coming_soon_dialog.dart';
import '../model/collection.dart';
import '../../../core/util/constants.dart';
import '../theme/home_theme.dart';

class CollectionButton extends StatelessWidget {
  const CollectionButton(this.collection, {super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (collection.routeName == 'Coming Soon') {
            showDialog(
              context: context,
              builder: (context) => const ComingSoonDialog(),
            );
            return;
          }
          if (collection.routeName.isNotEmpty) {
            Navigator.of(context).pushNamed(collection.routeName);
          }
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: isDark
                ? HomeTheme.darkCardElevated
                : kLightPrimary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : kLightPrimary.withValues(alpha: 0.15),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  collection.assetName,
                  width: 36.w,
                  height: 36.w,
                ),
                SizedBox(height: 6.h),
                Text(
                  collection.titleBuilder(context),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: HomeTheme.primaryText(context),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
