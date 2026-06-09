import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/bloc/dua/dua_bloc.dart';
import '../bloc/dropdown/dropdown_bloc.dart';
import '../theme/dua_theme.dart';
import '../widget/dua_category_card.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DuaBloc, DuaState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: DuaTheme.background(context),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: DuaTheme.background(context),
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(color: DuaTheme.primaryText(context)),
            title: Text('Dua', style: DuaTheme.appBarTitleStyle(context)),
          ),
          body: SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
              itemCount: state.duas.categorizedDuas.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: BlocProvider(
                    create: (context) => DropdownBloc(),
                    child: DuaCategoryCard(
                      state.duas.categorizedDuasList[index],
                      index + 1,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
