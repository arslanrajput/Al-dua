import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/util/constants.dart';

/// Al-Dua brand mark (launcher icon / splash / settings).
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size,
    this.borderRadius,
  });

  final double? size;
  final BorderRadius? borderRadius;

  static const String assetPath = 'assets/images/core/png/app_logo.png';

  @override
  Widget build(BuildContext context) {
    final side = size ?? 96.w;
    final radius = borderRadius ?? kAppIconBorderRadius;

    return ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        assetPath,
        width: side,
        height: side,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
