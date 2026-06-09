import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/home_theme.dart';
import 'ayat_card.dart';
import 'daily_challenge_card.dart';
import 'home_quick_links.dart';
import 'kiblat_card.dart';
import 'next_prayer_card.dart';
import 'spiritual_progress_card.dart';

class HomeSliverList extends StatelessWidget {
  const HomeSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ColoredBox(
        color: HomeTheme.screenBackground(context),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 120.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NextPrayerCard(),
              SizedBox(height: 12.h),
              const AyatCard(),
              SizedBox(height: 16.h),
              const HomeQuickLinks(),
              SizedBox(height: 10.h),
              const KiblatCard(),
              SizedBox(height: 8.h),
              const SpiritualProgressCard(),
              SizedBox(height: 8.h),
              const DailyChallengeCard(),
            ],
          ),
        ),
      ),
    );
  }
}
