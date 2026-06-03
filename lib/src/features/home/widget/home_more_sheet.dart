import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bottom_tab/bloc/tab/tab_bloc.dart';
import '../theme/home_theme.dart';

/// Menu shortcuts (features live on the home grid).
void showHomeMoreSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: HomeTheme.cardBackground(context),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.search_rounded, color: HomeTheme.accent),
                title: const Text('Search'),
                onTap: () {
                  Navigator.pop(ctx);
                  BlocProvider.of<TabBloc>(context).add(const SetTab(1));
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark_outline_rounded,
                    color: HomeTheme.accent),
                title: const Text('Bookmarks'),
                onTap: () {
                  Navigator.pop(ctx);
                  BlocProvider.of<TabBloc>(context).add(const SetTab(3));
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.settings_outlined, color: HomeTheme.accent),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(ctx);
                  BlocProvider.of<TabBloc>(context).add(const SetTab(4));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
