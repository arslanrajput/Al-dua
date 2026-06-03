import 'package:flutter/material.dart';

import 'package:al_dua/src/features/home/widget/home_sliver_appbar.dart';
import 'package:al_dua/src/features/home/widget/home_sliver_list.dart';

import '../theme/home_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HomeTheme.screenBackground(context),
      child: const CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          HomeSliverAppbar(),
          HomeSliverList(),
        ],
      ),
    );
  }
}
