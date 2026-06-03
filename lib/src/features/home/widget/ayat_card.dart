import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran/quran.dart';

import '../../../core/util/constants.dart';
import '../../../core/util/controller/share_controller.dart';
import '../theme/home_theme.dart';
import 'home_card.dart';

class AyatCard extends StatefulWidget {
  const AyatCard({super.key});

  @override
  State<AyatCard> createState() => _AyatCardState();
}

class _AyatCardState extends State<AyatCard> {
  late final RandomVerse _verse;

  @override
  void initState() {
    super.initState();
    _verse = RandomVerse();
  }

  String get _reference =>
      'Surah ${quran.getSurahName(_verse.surahNumber)}, ${_verse.verseNumber}';

  String get _shareText =>
      '${_verse.verse}\n\n${_verse.translation}\n\n— $_reference';

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: HomeTheme.accent.withValues(alpha: 0.7),
                size: 28.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'VERSE OF THE DAY',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: HomeTheme.mutedText(context),
                  ),
                ),
              ),
              Text(
                _reference,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: HomeTheme.mutedText(context),
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            _verse.verse,
            style: TextStyle(
              fontFamily: GoogleFonts.amiri().fontFamily,
              fontSize: 22.sp,
              height: 1.65,
              color: HomeTheme.primaryText(context),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.h),
          Text(
            '"${_verse.translation}"',
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: HomeTheme.mutedText(context),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onShare(_shareText),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HomeTheme.primaryText(context),
                    side: BorderSide(color: HomeTheme.cardBorder(context)),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _shareText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Verse copied — $kAppDisplayName'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bookmark_outline_rounded, size: 18),
                  label: const Text('Save'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? kDarkPrimary
                        : kLightPrimary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
