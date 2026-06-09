import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../../core/util/constants.dart';
import '../../home/theme/home_theme.dart';
import '../theme/azkar_theme.dart';
import '../util/azkar_category_icon.dart';
import '../screen/azkar_chapters_screen.dart';
import 'azkar_language.dart';

class AzkarCategoryTile extends StatelessWidget {
  const AzkarCategoryTile({
    super.key,
    required this.category,
    required this.language,
  });

  final AzkarCategory category;
  final AzkarLanguage language;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBg = isDark
        ? AzkarTheme.iconTileBgDark
        : AzkarTheme.iconTileBg;

    return Material(
      color: isDark ? HomeTheme.darkCardElevated : Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AzkarChaptersScreen(
                categoryId: category.id,
                categoryTitle: category.name,
                language: language,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  iconForAzkarCategory(category.name),
                  size: 24.sp,
                  color: kLightPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AzkarTheme.primaryText(context),
                      fontSize: 11.sp,
                      height: 1.2,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
