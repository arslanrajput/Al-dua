import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/home_theme.dart';
import 'home_card.dart';

class HadessCard extends StatelessWidget {
  const HadessCard({super.key});

  static const _hadees =
      '"A Muslim is a brother of another Muslim, so he should not oppress him, '
      'nor should he hand him over to an oppressor. Whoever has fulfilled the needs '
      'of his brother, Allah will fulfil his needs."';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionHeader(title: 'Hadees of the Day'),
        HomeCard(
          child: Column(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: HomeTheme.accent.withValues(alpha: 0.5),
                size: 28.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                _hadees,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                  color: HomeTheme.mutedText(context),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14.h),
              Divider(color: HomeTheme.cardBorder(context), height: 1),
              SizedBox(height: 12.h),
              Text(
                'Prophet Muhammad (PBUH)',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: HomeTheme.accent,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Sahih al-Bukhari',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: HomeTheme.mutedText(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
