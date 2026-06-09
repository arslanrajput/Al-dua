import '../../../core/util/model/timing.dart';

class NextPrayerDetails {
  const NextPrayerDetails({
    required this.name,
    required this.time,
    required this.remaining,
    required this.progress,
    required this.index,
  });

  final String name;
  final String time;
  final Duration remaining;
  /// 0.0–1.0 progress from previous prayer toward [name].
  final double progress;
  final int index;
}

DateTime? prayerTimeToday(String hhmm, DateTime now) {
  final parts = hhmm.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0].trim()) ?? 0;
  final m = int.tryParse(parts[1].trim().split(' ').first) ?? 0;
  return DateTime(now.year, now.month, now.day, h, m);
}

NextPrayerDetails? nextPrayerDetails(
  Timings t, {
  DateTime? referenceTime,
}) {
  final now = referenceTime ?? DateTime.now();
  final items = <MapEntry<String, String>>[
    MapEntry('Fajr', t.fajr),
    MapEntry('Dhuhr', t.dhuhr),
    MapEntry('Asr', t.asr),
    MapEntry('Maghrib', t.maghrib),
    MapEntry('Isha', t.isha),
  ];

  for (var i = 0; i < items.length; i++) {
    final at = prayerTimeToday(items[i].value, now);
    if (at != null && now.isBefore(at)) {
      final prevAt = i == 0
          ? prayerTimeToday(items.last.value, now)?.subtract(const Duration(days: 1))
          : prayerTimeToday(items[i - 1].value, now);
      var progress = 0.0;
      if (prevAt != null) {
        final span = at.difference(prevAt).inSeconds;
        final elapsed = now.difference(prevAt).inSeconds;
        if (span > 0) {
          progress = (elapsed / span).clamp(0.0, 1.0);
        }
      }
      return NextPrayerDetails(
        name: items[i].key,
        time: items[i].value,
        remaining: at.difference(now),
        progress: progress,
        index: i,
      );
    }
  }

  final fajr = prayerTimeToday(t.fajr, now);
  if (fajr == null) return null;
  final tomorrowFajr =
      DateTime(now.year, now.month, now.day + 1, fajr.hour, fajr.minute);
  final ishaAt = prayerTimeToday(t.isha, now);
  var progress = 0.0;
  if (ishaAt != null) {
    final span = tomorrowFajr.difference(ishaAt).inSeconds;
    final elapsed = now.difference(ishaAt).inSeconds;
    if (span > 0) {
      progress = (elapsed / span).clamp(0.0, 1.0);
    }
  }
  return NextPrayerDetails(
    name: 'Fajr',
    time: t.fajr,
    remaining: tomorrowFajr.difference(now),
    progress: progress,
    index: 0,
  );
}

int dayOffsetFromToday(DateTime day) {
  final today = DateTime.now();
  final a = DateTime(today.year, today.month, today.day);
  final b = DateTime(day.year, day.month, day.day);
  return b.difference(a).inDays;
}

bool isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String formatPrayerCountdownHms(Duration d) {
  if (d.isNegative) return '00:00:00';
  final h = d.inHours.toString().padLeft(2, '0');
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

int completedPrayersToday(Timings t) {
  final now = DateTime.now();
  final times = [t.fajr, t.dhuhr, t.asr, t.maghrib, t.isha];
  var count = 0;
  for (final time in times) {
    final at = prayerTimeToday(time, now);
    if (at != null && !now.isBefore(at)) {
      count++;
    }
  }
  return count;
}

String formatPrayerCountdown(Duration d) {
  if (d.isNegative) return '0 mins';
  if (d.inMinutes < 1) return '< 1 min';
  if (d.inMinutes < 60) return '${d.inMinutes} mins';
  final h = d.inHours;
  final mins = d.inMinutes.remainder(60);
  if (mins == 0) return '${h}h';
  return '${h}h ${mins}m';
}
