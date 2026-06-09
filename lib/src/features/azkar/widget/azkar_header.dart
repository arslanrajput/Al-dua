import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/azkar_theme.dart';
import 'azkar_language.dart';
import 'azkar_language_chip.dart';

/// REMEMBRANCE label, page title, and language selector (mockup).
class AzkarHeader extends StatelessWidget {
  const AzkarHeader({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AzkarLanguage language;
  final ValueChanged<AzkarLanguage> onLanguageChanged;

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
