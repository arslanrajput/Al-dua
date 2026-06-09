import 'package:muslim_data_flutter/muslim_data_flutter.dart';



/// Azkar UI languages. Urdu uses a bundled JSON overlay (not in muslim_data DB).

enum AzkarLanguage {

  en('en', Language.en),

  ur('ur', null),

  ar('ar', Language.ar),

  fa('fa', Language.fa),

  ckb('ckb', Language.ckb),

  ckbBadini('ckb_BADINI', Language.ckbBadini),

  ru('ru', Language.ru);



  const AzkarLanguage(this.dbCode, this.packageLanguage);



  final String dbCode;

  final Language? packageLanguage;

}



const List<AzkarLanguage> azkarSupportedLanguages = [

  AzkarLanguage.en,

  AzkarLanguage.ur,

  AzkarLanguage.ar,

  AzkarLanguage.fa,

  AzkarLanguage.ckb,

  AzkarLanguage.ckbBadini,

  AzkarLanguage.ru,

];



String azkarLanguageLabel(AzkarLanguage language) {

  switch (language) {

    case AzkarLanguage.en:

      return 'English';

    case AzkarLanguage.ur:

      return 'Urdu';

    case AzkarLanguage.ar:

      return 'Arabic';

    case AzkarLanguage.fa:

      return 'Persian';

    case AzkarLanguage.ckb:

      return 'Kurdish (Sorani)';

    case AzkarLanguage.ckbBadini:

      return 'Kurdish (Badini)';

    case AzkarLanguage.ru:

      return 'Russian';

  }

}

