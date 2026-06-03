import '../../../../routes/routes.dart';
import '../../../core/util/constants.dart';
import '../../../core/util/controller/share_controller.dart';
import '../../../core/util/controller/url_launcher_controller.dart';

class GeneralOption {
  final String imagePath;
  final String? routeName;
  final Function()? onTap;
  final String title;
  final String subtitle;

  GeneralOption({
    required this.imagePath,
    required this.onTap,
    required this.title,
    required this.subtitle,
    this.routeName,
  });
}

final List<GeneralOption> generalOptions = [
  GeneralOption(
    imagePath: 'assets/images/collection_icon/svg/quran.svg',
    onTap: null,
    routeName: RouteGenerator.quranSettings,
    title: 'Quran Settings',
    subtitle: 'Customize Quran font, translation mode and styling.',
  ),
  GeneralOption(
    imagePath: 'assets/images/collection_icon/svg/prayer_time.svg',
    onTap: null,
    routeName: RouteGenerator.prayerTimeSettings,
    title: 'Prayer Settings',
    subtitle: 'Madhab, Azan notifications, calculation method and adjustments.',
  ),
  GeneralOption(
    imagePath: 'assets/images/setting_icon/svg/donate.svg',
    onTap: null,
    routeName: RouteGenerator.thankyou,
    title: 'Support the App',
    subtitle: 'These generous contributors helped make this app a reality!',
  ),
  GeneralOption(
    imagePath: 'assets/images/setting_icon/svg/star.svg',
    onTap: () async {
      await launchURL(PLAY_STORE_URL);
    },
    title: 'Rate on App Store',
    subtitle: 'Enjoy using Al-Dua? '
        'Please leave a review to help other Muslims.',
  ),
  GeneralOption(
    imagePath: 'assets/images/setting_icon/svg/share.svg',
    onTap: () async {
      await onShare('Hey! Checkout this app '
          'https://play.google.com/store/apps/details?id=com.devtechnologies.aldua');
    },
    title: 'Share with a friend',
    subtitle: 'Tell others about the app with a link.',
  ),
];
