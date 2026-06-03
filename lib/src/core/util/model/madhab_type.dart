/// Islamic jurisprudence school used for prayer-time calculation (Asr in particular).
enum MadhabType {
  hanafi,
  shafi,
  maliki,
  hanbali;

  /// AlAdhan API `school` parameter: Hanafi = 1, all others = 0.
  int get schoolId => this == MadhabType.hanafi ? 1 : 0;

  String get label {
    switch (this) {
      case MadhabType.hanafi:
        return 'Hanafi';
      case MadhabType.shafi:
        return "Shafi'i";
      case MadhabType.maliki:
        return 'Maliki';
      case MadhabType.hanbali:
        return 'Hanbali';
    }
  }

  MadhabInfo get info => madhabMetadata[this]!;
}

class MadhabInfo {
  const MadhabInfo({
    required this.founder,
    required this.regions,
  });

  final String founder;
  final String regions;
}

extension MadhabTypeX on MadhabType {
  static MadhabType? fromIndex(int? index) {
    if (index == null) return null;
    if (index < 0 || index >= MadhabType.values.length) return null;
    return MadhabType.values[index];
  }

  /// Legacy school ids: 0 = Shafi (others), 1 = Hanafi.
  static MadhabType? fromLegacySchoolId(int? id) {
    if (id == null) return null;
    return id == 1 ? MadhabType.hanafi : MadhabType.shafi;
  }
}

const Map<MadhabType, MadhabInfo> madhabMetadata = {
  MadhabType.hanafi: MadhabInfo(
    founder: 'Imam Abu Hanifa',
    regions: 'Pakistan, India, Turkey, Central Asia',
  ),
  MadhabType.shafi: MadhabInfo(
    founder: "Imam Al-Shafi'i",
    regions: 'Indonesia, Malaysia, East Africa, Yemen',
  ),
  MadhabType.maliki: MadhabInfo(
    founder: 'Imam Malik ibn Anas',
    regions: 'North & West Africa',
  ),
  MadhabType.hanbali: MadhabInfo(
    founder: 'Imam Ahmad ibn Hanbal',
    regions: 'Saudi Arabia, Gulf countries',
  ),
};
