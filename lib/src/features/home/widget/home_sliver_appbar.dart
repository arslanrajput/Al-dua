import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../theme/home_theme.dart';

class HomeSliverAppbar extends StatelessWidget {
  const HomeSliverAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = HomeTheme.screenBackground(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      systemOverlayStyle: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: bg),
      centerTitle: true,
      title: Text(kAppDisplayName, style: HomeTheme.appTitleStyle(context)),
      toolbarHeight: 64.h,
    );
  }
}
