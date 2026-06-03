import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:al_dua/src/core/bloc/language_bloc/language_bloc.dart';
import 'package:al_dua/src/core/util/constants.dart';
import 'package:al_dua/src/core/util/model/language_model.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations._(context);
  }

  final BuildContext context;

  AppLocalizations._(this.context);

  AppLanguage get currentLanguage {
    return context.read<LanguageBloc>().state.selectedLanguage;
  }

  // Headings
  String get appName {
    switch (currentLanguage) {
      case AppLanguage.english:
        return kAppDisplayName;
      case AppLanguage.urdu:
        return 'الدعاء';
      case AppLanguage.arabic:
        return 'الدعاء';
      case AppLanguage.persian:
        return 'الدعاء';
      case AppLanguage.russian:
        return 'Аль-Дуа';
      case AppLanguage.kurdishSorani:
        return 'ئەل-دعا';
      case AppLanguage.kurdishBadini:
        return 'ئەل-دعا';
    }
  }

  // Home Screen
  String get quran {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Quran';
      case AppLanguage.urdu:
        return 'قرآن';
      case AppLanguage.arabic:
        return 'القرآن';
      case AppLanguage.persian:
        return 'قرآن';
      case AppLanguage.russian:
        return 'Құран';
      case AppLanguage.kurdishSorani:
        return 'قورئان';
      case AppLanguage.kurdishBadini:
        return 'قورئان';
    }
  }

  String get prayerTimes {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Prayer Times';
      case AppLanguage.urdu:
        return 'نماز کے اوقات';
      case AppLanguage.arabic:
        return 'مواقيت الصلاة';
      case AppLanguage.persian:
        return 'اوقات نماز';
      case AppLanguage.russian:
        return 'Намаз уақыттары';
      case AppLanguage.kurdishSorani:
        return 'کاتی نوێژ';
      case AppLanguage.kurdishBadini:
        return 'کاتی نوێژ';
    }
  }

  String get qibla {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Qibla';
      case AppLanguage.urdu:
        return 'قبلہ';
      case AppLanguage.arabic:
        return 'القبلة';
      case AppLanguage.persian:
        return 'قبلہ';
      case AppLanguage.russian:
        return 'Қибла';
      case AppLanguage.kurdishSorani:
        return 'قبلة';
      case AppLanguage.kurdishBadini:
        return 'قبلة';
    }
  }

  String get tasbih {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Tasbih';
      case AppLanguage.urdu:
        return 'تسبیح';
      case AppLanguage.arabic:
        return 'تسبيح';
      case AppLanguage.persian:
        return 'تسبیح';
      case AppLanguage.russian:
        return 'Тасбих';
      case AppLanguage.kurdishSorani:
        return 'تسبیح';
      case AppLanguage.kurdishBadini:
        return 'تسبیح';
    }
  }

  String get dua {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Dua';
      case AppLanguage.urdu:
        return 'دعا';
      case AppLanguage.arabic:
        return 'دعاء';
      case AppLanguage.persian:
        return 'دعا';
      case AppLanguage.russian:
        return 'Дуа';
      case AppLanguage.kurdishSorani:
        return 'دعا';
      case AppLanguage.kurdishBadini:
        return 'دعا';
    }
  }

  String get azkar {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Azkar';
      case AppLanguage.urdu:
        return 'اذکار';
      case AppLanguage.arabic:
        return 'أذكار';
      case AppLanguage.persian:
        return 'اذکار';
      case AppLanguage.russian:
        return 'Әзкар';
      case AppLanguage.kurdishSorani:
        return 'ئەھکار';
      case AppLanguage.kurdishBadini:
        return 'ئەھکار';
    }
  }

  String get allahNames {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Names of Allah';
      case AppLanguage.urdu:
        return 'اللہ کے نام';
      case AppLanguage.arabic:
        return 'أسماء الله';
      case AppLanguage.persian:
        return 'نامهای خدا';
      case AppLanguage.russian:
        return 'Аллаһ атаулары';
      case AppLanguage.kurdishSorani:
        return 'ناوەکانی خوا';
      case AppLanguage.kurdishBadini:
        return 'ناوەکانی خوا';
    }
  }

  String get bookmarks {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Bookmarks';
      case AppLanguage.urdu:
        return 'بک مارکس';
      case AppLanguage.arabic:
        return 'المرجعيات';
      case AppLanguage.persian:
        return 'نشانک‌ها';
      case AppLanguage.russian:
        return 'Бетбелгілер';
      case AppLanguage.kurdishSorani:
        return 'نیشانەکان';
      case AppLanguage.kurdishBadini:
        return 'نیشانەکان';
    }
  }

  String get settings {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Settings';
      case AppLanguage.urdu:
        return 'ترتیبات';
      case AppLanguage.arabic:
        return 'الإعدادات';
      case AppLanguage.persian:
        return 'تنظیمات';
      case AppLanguage.russian:
        return 'Баптаулар';
      case AppLanguage.kurdishSorani:
        return 'ڕێکخستنەکان';
      case AppLanguage.kurdishBadini:
        return 'ڕێکخستنەکان';
    }
  }

  String get language {
    switch (currentLanguage) {
      case AppLanguage.english:
        return 'Language';
      case AppLanguage.urdu:
        return 'زبان';
      case AppLanguage.arabic:
        return 'اللغة';
      case AppLanguage.persian:
        return 'زبان';
      case AppLanguage.russian:
        return 'Тіл';
      case AppLanguage.kurdishSorani:
        return 'زمان';
      case AppLanguage.kurdishBadini:
        return 'زمان';
    }
  }
}
