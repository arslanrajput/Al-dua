import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Display name shown in app UI, launcher (where set), and share text.
const String kAppDisplayName = 'Al-Dua';

const String PRAYER_TIMING_URL = 'https://api.aladhan.com/v1/timings/';

const String DATABASE_FILE = 'al_dua.db';

const String kGoogleCloudApiKey = 'AIzaSyDnDR3I9DV5lTCzRVDmuFVNz3gqz_QckgU<';

/* const String PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=com.devtechnologies.aldua';
const WEBSITE_URL = 'https://talhasultan.dev/';
const EMAIL_URL =
    'mailto:talhasultan.dev@gmail.com?subject=Al-Dua%20Query';
const MEDIUM_URL = 'https://medium.com/@muhammadtalhasultan';
const YOUTUBE_URL = 'https://www.youtube.com/channel/UC-cBM3nBHd5t6BKKznR3GNg';
const FACEBOOK_URL = 'https://www.facebook.com/groups/218761196363628';
const INSTA_URL = 'https://www.instagram.com/talhasultandev/'; */


const String PLAY_STORE_URL =
    'https://play.google.com/store/apps/';
const WEBSITE_URL = 'https://www.google.com';
const EMAIL_URL =
    'mailto:';
const MEDIUM_URL = 'https://medium.com/';
const YOUTUBE_URL = 'https://www.youtube.com/';
const FACEBOOK_URL = 'https://www.facebook.com/';
const INSTA_URL = 'https://www.instagram.com/';

// Brand palette — dark green (matches launcher / splash logo background)
const Color kBrandLogoGreen = Color(0xFF0B4D35);
const Color kBrandLogoGold = Color(0xFFD4AF37);

const Color kLightPrimary = Color(0xFF0F6B4A);
const Color kLightAccent = Color(0xFF2D9B6E);
const Color kLightTextColor = Color(0xFF0D1F18);
const Color kLightPlaceholder = Color(0xFFE2EDE8);
const Color kLightPlaceholderText = Color(0xFF9BB5A8);
const Color kLightBg = Color(0xFFF5FAF7);
const Color kLightError = Color(0xFFC94A42);

const Color kDarkPrimary = Color(0xFF2DB87A);
const Color kDarkAccent = Color(0xFF5DD39E);
const Color kDarkTextColor = Colors.white;
const Color kDarkPlaceholder = Color(0xFF1A3329);
const Color kDarkPlaceholderText = Color(0xFF0E1F19);
const Color kDarkBg = Color(0xFF071510);
const Color kDarkError = Color(0xFFE57373);

const Duration kAnimationDuration = Duration(milliseconds: 300);
const Curve kAnimationCurve = Curves.easeInOut;
const double kCategoryTileHeight = 58;

EdgeInsets kPagePadding = EdgeInsets.symmetric(
  horizontal: 12.w,
);

EdgeInsets kCardPadding = EdgeInsets.symmetric(
  horizontal: 16.w,
  vertical: 16.h,
);

EdgeInsets kInputFieldPadding = EdgeInsets.symmetric(
  horizontal: 16.w,
  vertical: 16.h,
);

BorderRadiusGeometry kCardBorderRadius = BorderRadius.circular(
  16.r,
);

BorderRadius kAppIconBorderRadius = BorderRadius.circular(
  8.r,
);

BorderRadiusGeometry kBottomSheetBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(16.r),
  topRight: Radius.circular(16.r),
);
