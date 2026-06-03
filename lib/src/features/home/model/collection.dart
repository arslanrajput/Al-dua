import '../../../../routes/routes.dart';
import 'package:flutter/material.dart';
import '../../../core/util/app_localizations.dart';

class Collection {
  final String assetName;
  final String Function(BuildContext) titleBuilder;
  final String routeName;

  Collection(this.assetName, this.titleBuilder, this.routeName);
}

List<Collection> collections(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return [
    Collection(
      'assets/images/collection_icon/svg/quran.svg',
      (context) => l10n.quran,
      RouteGenerator.quran,
    ),
    Collection(
      'assets/images/collection_icon/svg/duas.svg',
      (context) => l10n.dua,
      RouteGenerator.dua,
    ),
    Collection(
      'assets/images/collection_icon/svg/tasbih.svg',
      (context) => l10n.tasbih,
      RouteGenerator.tasbih,
    ),
    Collection(
      'assets/images/collection_icon/svg/other.svg',
      (context) => l10n.azkar,
      RouteGenerator.azkar,
    ),
    Collection(
      'assets/images/collection_icon/svg/allah.svg',
      (context) => l10n.allahNames,
      RouteGenerator.allahName,
    ),
    Collection(
      'assets/images/collection_icon/svg/prayer_time.svg',
      (context) => l10n.prayerTimes,
      RouteGenerator.prayerTimingPage,
    ),
    Collection(
      'assets/images/collection_icon/svg/kiblat.svg',
      (context) => l10n.qibla,
      RouteGenerator.qibla,
    ),
    Collection(
      'assets/images/collection_icon/svg/qaabah.svg',
      (context) => 'Live TV',
      RouteGenerator.liveTv,
    ),
  ];
}
