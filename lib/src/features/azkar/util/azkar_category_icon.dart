import 'package:flutter/material.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

/// Maps Azkar category titles to Material icons (mockup-style).
IconData iconForAzkarCategory(String title) {
  final t = title.toLowerCase();

  if (t.contains('evening') && !t.contains('morning')) {
    return Icons.nightlight_round;
  }
  if (t.contains('morning')) {
    return Icons.wb_sunny_outlined;
  }
  if (t.contains('home') || t.contains('family')) {
    return Icons.family_restroom_outlined;
  }
  if (t.contains('food') || t.contains('drink')) {
    return Icons.restaurant_outlined;
  }
  if (t.contains('joy') || t.contains('distress') || t.contains('happy')) {
    return Icons.sentiment_satisfied_alt_outlined;
  }
  if (t.contains('travel') || t.contains('journey')) {
    return Icons.flight_outlined;
  }
  if (t.contains('prayer') || t.contains('salah') || t.contains('mosque')) {
    return Icons.mosque_outlined;
  }
  if (t.contains('prais') || (t.contains('allah') && t.contains('name'))) {
    return Icons.monitor_heart_outlined;
  }
  if (t.contains('hajj') || t.contains('umrah') || t.contains('kaaba')) {
    return Icons.home_work_outlined;
  }
  if (t.contains('etiquette') || t.contains('manners') || t.contains('character')) {
    return Icons.handshake_outlined;
  }
  if (t.contains('nature') || t.contains('weather')) {
    return Icons.park_outlined;
  }
  if (t.contains('sick') || t.contains('death') || t.contains('funeral')) {
    return Icons.single_bed_outlined;
  }
  if (t.contains('general') || t.contains('misc')) {
    return Icons.grid_view_rounded;
  }
  if (t.contains('sleep') || t.contains('night')) {
    return Icons.bedtime_outlined;
  }
  if (t.contains('ramadan') || t.contains('fast')) {
    return Icons.nights_stay_outlined;
  }

  return Icons.auto_awesome_outlined;
}

AzkarCategory? findMorningAzkarCategory(List<AzkarCategory> categories) {
  for (final c in categories) {
    final lower = c.name.toLowerCase();
    if (lower.contains('morning') ||
        lower.contains('morning & evening') ||
        lower.contains('evening & morning')) {
      return c;
    }
  }
  if (categories.isEmpty) return null;
  return categories.first;
}
