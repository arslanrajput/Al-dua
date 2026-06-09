/// Parses prayer time strings from AlAdhan (e.g. `18:22`, `18:22 (PKT)`).
class PrayerTimeParser {
  static final RegExp _timePattern = RegExp(r'(\d{1,2}):(\d{2})');

  static int? parseHour(String time) {
    final match = _timePattern.firstMatch(time.trim());
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  static int? parseMinute(String time) {
    final match = _timePattern.firstMatch(time.trim());
    if (match == null) return null;
    return int.tryParse(match.group(2)!);
  }

  static bool isValid(String time) {
    return parseHour(time) != null && parseMinute(time) != null;
  }
}
