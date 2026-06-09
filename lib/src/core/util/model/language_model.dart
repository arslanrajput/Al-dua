enum AppLanguage {
  english('en', 'English', '🇬🇧'),
  urdu('ur', 'اردو', '🇵🇰'),
  arabic('ar', 'العربية', '🇸🇦'),
  persian('fa', 'فارسی', '🇮🇷'),
  russian('ru', 'Русский', '🇷🇺'),
  kurdishSorani('ku', 'کوردی (سۆرانی)', '🏴'),
  kurdishBadini('ku-IR', 'کوردی (بادینی)', '🏴');

  const AppLanguage(this.code, this.displayName, this.flag);
  
  final String code;
  final String displayName;
  final String flag;
  
  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
