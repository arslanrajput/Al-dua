import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../../../core/util/model/dua.dart';
import '../bloc/dropdown/dropdown_bloc.dart';
import '../theme/dua_theme.dart';
import 'dua_card.dart';

class DuaCategoryCard extends StatelessWidget {
  const DuaCategoryCard(this.surah, this.index);

  final MapEntry<String, List<Dua>> surah;
  final int index;

  @override
  Widget build(BuildContext context) {
    final primary = DuaTheme.primaryText(context);

    return Column(
      children: [
        Material(
          color: DuaTheme.categoryBackground(context),
          borderRadius: BorderRadius.circular(12.r),
          elevation: 0,
          child: InkWell(
            onTap: () {
              BlocProvider.of<DropdownBloc>(context).add(ToggleDropdown());
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: DuaTheme.categoryBorder(context)),
                boxShadow: DuaTheme.categoryCardShadow(context),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: DuaTheme.indexBadgeBackground(context),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        index.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          surah.key,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Jameel',
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                            color: primary,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<DropdownBloc, DropdownState>(
                      builder: (context, state) {
                        return Icon(
                          state.expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: DuaTheme.chevronColor(context),
                          size: 26.sp,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<DropdownBloc, DropdownState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: kAnimationDuration,
              switchInCurve: kAnimationCurve,
              reverseDuration: Duration.zero,
              child: state.expanded
                  ? Column(
                      children: List.generate(surah.value.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: i == 0 ? 10.h : 8.h,
                          ),
                          child: DuaCard(surah.value[i]),
                        );
                      }),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
