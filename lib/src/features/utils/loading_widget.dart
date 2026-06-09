import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/util/constants.dart';
import 'app_logo.dart';

/// Branded loading indicator (Al-Dua).
class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 88.w,
            height: 88.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: _controller,
                  child: SizedBox(
                    width: 88.w,
                    height: 88.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: kBrandLogoGreen.withValues(alpha: 0.35),
                      backgroundColor: kBrandLogoGreen.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: Tween(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: AppLogo(
                    size: 48.w,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Loading',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: kBrandLogoGreen,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8.h),
          _LoadingDots(animation: _controller),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final phase = (animation.value + index * 0.2) % 1.0;
            final opacity = 0.35 + (0.65 * (1 - (phase - 0.5).abs() * 2).clamp(0.0, 1.0));
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: kBrandLogoGreen.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
