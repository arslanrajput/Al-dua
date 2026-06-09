import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../../core/util/bloc/juz/juz_bloc.dart';
import '../../../core/util/bloc/surah/surah_bloc.dart';
import '../../bottom_tab/bloc/tab/tab_bloc.dart' as btb;
import '../bloc/tab/tab_bloc.dart' as qtb;
import '../cubit/quran_cubit.dart';
import '../cubit/quran_reading_cubit.dart';
import '../screen/quran_search_screen.dart';
import 'juz_card.dart';
import 'quran_last_read_section.dart';
import 'quran_tab.dart';
import 'surah_card.dart';

class QuranScaffold extends StatelessWidget {
  const QuranScaffold();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final overlay = (brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          brightness == Brightness.dark ? Brightness.dark : Brightness.light,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        systemOverlayStyle: overlay,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        title: Text(
          'Al-Quran',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              if (!BlocProvider.of<QuranCubit>(context).state.fromNav)
                Navigator.of(context).pop();
              BlocProvider.of<btb.TabBloc>(context).add(btb.SetTab(2));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: SvgPicture.asset(
                'assets/images/navigation_icon/svg/bookmark_nfill.svg',
                width: 24.w,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final quranCubit = BlocProvider.of<QuranCubit>(context);
              QuranReadingCubit? readingCubit;
              try {
                readingCubit = BlocProvider.of<QuranReadingCubit>(context);
              } catch (_) {
                readingCubit = null;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider<QuranCubit>.value(value: quranCubit),
                      if (readingCubit != null)
                        BlocProvider<QuranReadingCubit>.value(
                            value: readingCubit),
                    ],
                    child: const QuranSearchScreen(),
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: SvgPicture.asset(
                'assets/images/navigation_icon/svg/search.svg',
                width: 24.w,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.h,
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 32.w),
            //   child: Text(
            //     'Al-Qur\'an',
            //     style: Theme.of(context).textTheme.displayMedium!.copyWith(
            //           fontWeight: FontWeight.bold,
            //         ),
            //   ),
            // ),
            // SizedBox(
            //   height: 16.h,
            // ),
            QuranTab(),
            const QuranLastReadSection(),
            BlocBuilder<qtb.TabBloc, qtb.TabState>(
              builder: (context, tabState) {
                return Expanded(
                  child: PageView.builder(
                      controller: tabState.controller,
                      itemCount: 2,
                      onPageChanged: (index) {
                        BlocProvider.of<qtb.TabBloc>(context)
                            .add(qtb.ToggleTab(index == 0));
                      },
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return BlocBuilder<SurahBloc, SurahState>(
                            builder: (context, state) {
                              return ListView.builder(
                                  itemCount: state.surahs.surahs.length,
                                  itemBuilder: (context, index) {
                                    return SurahCard(
                                      state.surahs,
                                      index,
                                    );
                                  });
                            },
                          );
                        } else {
                          return BlocBuilder<JuzBloc, JuzState>(
                            builder: (context, state) {
                              return ListView.builder(
                                  itemCount: state.juzs.juzs.length,
                                  itemBuilder: (context, index) {
                                    return JuzCard(
                                      state.juzs,
                                      index,
                                    );
                                  });
                            },
                          );
                        }
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
