import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../screen/name_screen.dart';
import '../theme/allah_name_theme.dart';

class NameCard extends StatelessWidget {
  const NameCard({
    super.key,
    required this.name,
    required this.index,
  });

  final NameOfAllah name;
  final int index;

  String get _indexLabel => index.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NameScreen(name),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            decoration: BoxDecoration(
              color: AllahNameTheme.cardBg(context),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AllahNameTheme.indexBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      _indexLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AllahNameTheme.mutedText(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.transliteration.toUpperCase(),
                          style: AllahNameTheme.transliterationStyle(context),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          name.translation,
                          style: AllahNameTheme.meaningStyle(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    name.name,
                    style: AllahNameTheme.arabicStyle(context),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

