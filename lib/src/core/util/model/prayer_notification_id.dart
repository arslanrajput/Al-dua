/// Stable notification ids for the five daily prayers.
enum PrayerNotificationId {
  fajr(1001, 'Fajr'),
  dhuhr(1002, 'Dhuhr'),
  asr(1003, 'Asr'),
  maghrib(1004, 'Maghrib'),
  isha(1005, 'Isha');

  const PrayerNotificationId(this.id, this.prayerName);

  final int id;
  final String prayerName;

  static PrayerNotificationId? fromPrayerName(String name) {
    for (final p in PrayerNotificationId.values) {
      if (p.prayerName.toLowerCase() == name.toLowerCase()) {
        return p;
      }
    }
    return null;
  }
}
