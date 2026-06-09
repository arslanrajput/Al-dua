import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/allah_names/allah_name_bloc.dart';
import '../../../core/util/theme.dart';
import '../../home/theme/home_theme.dart';
import '../../utils/loading_widget.dart';
import '../theme/allah_name_theme.dart';
import '../widget/allah_name_header.dart';
import '../widget/allah_name_quote_banner.dart';
import '../widget/name_card.dart';

class AllahNameScreen extends StatelessWidget {
  const AllahNameScreen();

  static const int _quoteBannerAfterIndex = 4;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllahNameBloc, AllahNameState>(
      builder: (context, state) {
        if (state.allahNames.isEmpty) {
          BlocProvider.of<AllahNameBloc>(context).add(
            FetchAllahName(),
          );
        }

        return Scaffold(
          backgroundColor: AllahNameTheme.screenBg(context),
          appBar: AppBar(
            backgroundColor: AllahNameTheme.screenBg(context),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: HomeTheme.primaryText(context)),
            title: Text(
              '99 Names',
              style: appBarTitleTextStyle(
                color: HomeTheme.primaryText(context),
                fontSize: 20.sp,
              ),
            ),
          ),
          body: SafeArea(
            child: state.allahNames.isEmpty
                ? const LoadingWidget()
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    itemCount: state.allahNames.length + 1,
                    itemBuilder: (context, listIndex) {
                      if (listIndex == 0) {
                        return const AllahNameHeader();
                      }

                      final nameIndex = listIndex - 1;
                      final showBanner =
                          nameIndex == _quoteBannerAfterIndex;

                      return Column(
                        children: [
                          if (showBanner) const AllahNameQuoteBanner(),
                          NameCard(
                            name: state.allahNames[nameIndex],
                            index: nameIndex + 1,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
