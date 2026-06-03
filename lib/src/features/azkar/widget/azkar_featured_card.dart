import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../home/theme/home_theme.dart';
import '../screen/azkar_chapters_screen.dart';

class AzkarFeaturedCard extends StatelessWidget {
  const AzkarFeaturedCard({
    super.key,
    required this.category,
    required this.language,
    this.title = 'Morning Azkar',
  });

  final AzkarCategory category;
  final Language language;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HomeTheme.nextPrayerGreen,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: HomeTheme.nextPrayerGreen.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 10.h),
          Text(
            '"Verily, in the remembrance of Allah do hearts find rest."',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  height: 1.45,
                  fontStyle: FontStyle.italic,
                ),
          ),
          SizedBox(height: 18.h),
          Material(
            color: HomeTheme.highlight,
            borderRadius: BorderRadius.circular(24.r),
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
              borderRadius: BorderRadius.circular(24.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Read Now',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF3D3420),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20.sp,
                      color: const Color(0xFF3D3420),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
