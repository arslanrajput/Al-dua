import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    show AlignedGridView;

import '../../../core/util/app_localizations.dart';
import '../model/collection.dart';
import 'collection_button.dart';
import 'home_card.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      child: AlignedGridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: collections(context).length,
        itemBuilder: (context, index) {
          return CollectionButton(collections(context)[index]);
        },
      ),
    );
  }
}
