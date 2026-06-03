import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../utils/bottom_sheet_select.dart';
import '../theme/azkar_theme.dart';
import 'azkar_language.dart';

class AzkarLanguageChip extends StatelessWidget {
  const AzkarLanguageChip({
    super.key,
    required this.language,
    required this.onChanged,
  });

  final Language language;
  final ValueChanged<Language> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipBg =
        isDark ? AzkarTheme.languageChipBgDark : AzkarTheme.languageChipBg;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: BottomSheetSelect<Language>(
        dense: true,
        shrinkWrapWidth: true,
        label: '',
        value: azkarSupportedLanguages.contains(language)
            ? language
            : azkarSupportedLanguages.first,
        options: azkarSupportedLanguages,
        optionLabelBuilder: azkarLanguageLabel,
        selectedLabelBuilder: azkarLanguageLabel,
        onChanged: onChanged,
      ),
    );
  }
}
