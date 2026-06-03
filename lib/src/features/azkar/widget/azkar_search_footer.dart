import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bottom_tab/bloc/tab/tab_bloc.dart';
import '../theme/azkar_theme.dart';

class AzkarSearchFooter extends StatelessWidget {
  const AzkarSearchFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AzkarTheme.footerCardBgDark : AzkarTheme.footerCardBg,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => _openSearch(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 28.sp,
                    color: AzkarTheme.primaryText(context).withValues(alpha: 0.5),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.menu_book_outlined,
                    size: 24.sp,
                    color: AzkarTheme.primaryText(context).withValues(alpha: 0.4),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                "Can't find a Dua? Search our library of 500+ authentic supplications.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AzkarTheme.primaryText(context),
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    try {
      context.read<TabBloc>().add(SetTab(1));
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Open Search from the bottom navigation bar.'),
        ),
      );
    }
  }
}
