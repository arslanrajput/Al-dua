import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/coming_soon_dialog.dart';
import '../model/collection.dart';
import '../theme/home_theme.dart';

class HomeQuickLinks extends StatelessWidget {
  const HomeQuickLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final links = collections(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 6.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 0.9,
      ),
      itemCount: links.length,
      itemBuilder: (context, index) {
        return _QuickLinkTile(collection: links[index]);
      },
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({required this.collection});

  final Collection collection;

  void _onTap(BuildContext context) {
    if (collection.routeName == 'Coming Soon') {
      showDialog(
        context: context,
        builder: (context) => const ComingSoonDialog(),
      );
      return;
    }
    if (collection.routeName.isNotEmpty) {
      Navigator.of(context).pushNamed(collection.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: HomeTheme.featureTileColor(context),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () => _onTap(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                collection.assetName,
                width: 40.w,
                height: 40.w,
              ),
              SizedBox(height: 6.h),
              Text(
                collection.titleBuilder(context),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: HomeTheme.primaryText(context),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
