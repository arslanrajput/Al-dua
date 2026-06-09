import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../home/theme/home_theme.dart';

/// Last-read banner on the Al-Quran list (typography matches app theme).
class LastReadCard extends StatelessWidget {
  const LastReadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeNumber,
    required this.badgeLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final int badgeNumber;
  final String badgeLabel;
  final VoidCallback onTap;

  static String arabicNumerals(int value) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return value
        .toString()
        .split('')
        .map((c) => digits[int.parse(c)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardGreen =
        isDark ? HomeTheme.nextPrayerGreenDark : HomeTheme.nextPrayerGreen;
    final onCard = Colors.yellow;
    final onCardMuted = onCard.withValues(alpha: 0.7);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Material(
        color: cardGreen,
        borderRadius: kCardBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LAST READ',
                        style: HomeTheme.sectionTitleStyle(context).copyWith(
                          color: onCardMuted,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24.sp
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onCardMuted,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _ContinueButton(onTap: onTap),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                _SurahBadge(
                  number: badgeNumber,
                  label: badgeLabel,
                  theme: theme,
                  onCard: Colors.white.withValues(alpha: 0.80),
                  onCardMuted: onCardMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onTap,
      style: theme.elevatedButtonTheme.style?.copyWith(
        minimumSize: WidgetStateProperty.all(Size.zero),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
        backgroundColor: WidgetStateProperty.all(theme.colorScheme.primary),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(
          theme.brightness == Brightness.light ? 4 : 0,
        ),
        shape: WidgetStateProperty.all(const StadiumBorder()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Continue Reading',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.arrow_forward_rounded, size: 18.sp),
        ],
      ),
    );
  }
}

class _SurahBadge extends StatelessWidget {
  const _SurahBadge({
    required this.number,
    required this.label,
    required this.theme,
    required this.onCard,
    required this.onCardMuted,
  });

  final int number;
  final String label;
  final ThemeData theme;
  final Color onCard;
  final Color onCardMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: onCard.withValues(alpha: 0.12),
        borderRadius: kAppIconBorderRadius,
        border: Border.all(color: onCard.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LastReadCard.arabicNumerals(number),
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: 'arsura',
              fontSize: 28.sp,
              color: onCard,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label.toUpperCase(),
            style: HomeTheme.sectionTitleStyle(context).copyWith(
              color: onCardMuted,
            ),
          ),
        ],
      ),
    );
  }
}
