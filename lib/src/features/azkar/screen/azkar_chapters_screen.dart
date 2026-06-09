import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../../core/util/constants.dart';
import '../../../core/util/theme.dart';
import '../../home/theme/home_theme.dart';
import '../../utils/loading_widget.dart';
import '../cubit/azkar_chapters_cubit.dart';
import '../cubit/azkar_categories_cubit.dart';
import '../theme/azkar_theme.dart';
import '../widget/azkar_language.dart';
import 'azkar_items_screen.dart';

class AzkarChaptersScreen extends StatelessWidget {
  const AzkarChaptersScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.language,
  });

  final int categoryId;
  final String categoryTitle;
  final AzkarLanguage language;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarChaptersCubit(
        categoryId: categoryId,
        categoryTitle: categoryTitle,
        language: language,
      )..load(),
      child: const _AzkarChaptersView(),
    );
  }
}

class _AzkarChaptersView extends StatelessWidget {
  const _AzkarChaptersView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarChaptersCubit, AzkarChaptersState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AzkarTheme.background(context),
          appBar: AppBar(
            backgroundColor: AzkarTheme.background(context),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AzkarTheme.primaryText(context)),
            title: Text(
              state.categoryTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appBarTitleTextStyle(
                color: AzkarTheme.primaryText(context),
                fontSize: 18.sp,
              ),
            ),
          ),
          body: SafeArea(
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AzkarChaptersState state) {
    if (state.status == AzkarLoadStatus.loading ||
        state.status == AzkarLoadStatus.initial) {
      return const LoadingWidget();
    }
    if (state.status == AzkarLoadStatus.error) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            state.errorMessage ?? 'Something went wrong.',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.chapters.isEmpty) {
      return Center(
        child: Text(
          'No chapters found.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
      children: [
        _CategoryHeroCard(title: state.categoryTitle),
        SizedBox(height: 16.h),
        ...state.chapters.map(
          (chapter) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _ChapterTile(
              title: chapter.name,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AzkarItemsScreen(
                      chapterId: chapter.id,
                      chapterTitle: chapter.name,
                      language: state.language,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _BottomQuoteCard(title: state.categoryTitle),
      ],
    );
  }
}

class _CategoryHeroCard extends StatelessWidget {
  const _CategoryHeroCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HomeTheme.nextPrayerGreen,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY ROUTINE',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Find tranquility through the remembrance of Allah in your daily life.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? HomeTheme.darkCardElevated : Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: isDark ? AzkarTheme.iconTileBgDark : AzkarTheme.iconTileBg,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _chapterIcon(title),
                  color: kLightPrimary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AzkarTheme.primaryText(context),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: HomeTheme.mutedText(context),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _chapterIcon(String text) {
    final t = text.toLowerCase();
    if (t.contains('morning')) return Icons.wb_sunny_outlined;
    if (t.contains('evening') || t.contains('night')) return Icons.nights_stay_outlined;
    if (t.contains('sleep')) return Icons.bedtime_outlined;
    if (t.contains('waking') || t.contains('wake')) return Icons.wb_twilight_outlined;
    if (t.contains('home') || t.contains('family')) return Icons.family_restroom_outlined;
    if (t.contains('food') || t.contains('drink')) return Icons.restaurant_outlined;
    if (t.contains('travel')) return Icons.flight_outlined;
    if (t.contains('prayer') || t.contains('salah')) return Icons.mosque_outlined;
    if (t.contains('hajj') || t.contains('umrah')) return Icons.home_work_outlined;
    if (t.contains('nature')) return Icons.park_outlined;
    if (t.contains('sick')) return Icons.local_hospital_outlined;
    return Icons.auto_awesome_outlined;
  }
}

class _BottomQuoteCard extends StatelessWidget {
  const _BottomQuoteCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: isDark ? AzkarTheme.footerCardBgDark : const Color(0xFFEFF6F2),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: (isDark ? Colors.white : kLightPrimary).withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote_rounded, color: kLightPrimary, size: 32.sp),
          SizedBox(height: 8.h),
          Text(
            '"Unquestionably, by the remembrance of Allah hearts are assured."',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AzkarTheme.primaryText(context),
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AzkarTheme.mutedText(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

