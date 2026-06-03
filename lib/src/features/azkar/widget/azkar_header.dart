import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../theme/azkar_theme.dart';
import 'azkar_language_chip.dart';

/// REMEMBRANCE label, page title, and language selector (mockup).
class AzkarHeader extends StatelessWidget {
  const AzkarHeader({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final Language language;
  final ValueChanged<Language> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('REMEMBRANCE', style: AzkarTheme.sectionLabelStyle(context)),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Daily Supplications',
                  style: AzkarTheme.pageTitleStyle(context),
                ),
              ),
              SizedBox(width: 8.w),
              AzkarLanguageChip(
                language: language,
                onChanged: onLanguageChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
