import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/util/bloc/dua/dua_bloc.dart';
import '../../../core/util/model/dua.dart';
import '../../bookmark/bloc/category_bloc.dart';
import '../controller/dua_controller.dart';
import '../theme/dua_theme.dart';

class DuaCard extends StatelessWidget {
  const DuaCard(this.dua, {this.bookmarkScreen = false});

  final Dua dua;
  final bool bookmarkScreen;

  @override
  Widget build(BuildContext context) {
    final primary = DuaTheme.primaryText(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: DuaTheme.contentCardBackground(context),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: DuaTheme.contentCardShadow(context),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/dua_icon/svg/bismillah.svg',
            colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
            width: 0.38.sw,
          ),
          SizedBox(height: 10.h),
          Text(
            dua.aya,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Uthman',
              fontSize: 18.sp,
              color: primary,
              height: 1.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(
              height: 1,
              thickness: 1,
              color: DuaTheme.dividerColor(context),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Aya: ${dua.ayaNumber} ${dua.surah}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: DuaTheme.mutedText(context),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await toggleDuaFavorite(context, dua);

                  if (bookmarkScreen) {
                    await Future.delayed(Duration.zero);

                    BlocProvider.of<CategoryBloc>(context).add(
                      UpdateFavoriteItem(
                        duas: BlocProvider.of<DuaBloc>(context).state.duas,
                      ),
                    );
                  }
                },
                child: SvgPicture.asset(
                  dua.favorite == 0
                      ? 'assets/images/tasbih_icon/svg/favorite.svg'
                      : 'assets/images/tasbih_icon/svg/favorite_filled.svg',
                  colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                  width: 22.w,
                  height: 22.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
