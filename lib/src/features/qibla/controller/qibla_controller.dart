/// Bearing from user position to the Kaaba (great-circle initial bearing).
///
/// KAABA: lat 21.4224779, lng 39.8251832
/// θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
/// 0° = north, 90° = east (clockwise).
import 'dart:math' show sin, cos, atan2, pi, asin, sqrt;

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, radians;

const _kaabaLatDeg = 21.4224779;
const _kaabaLngDeg = 39.8251832;
final _kaabaLat = radians(_kaabaLatDeg);
final _kaabaLng = radians(_kaabaLngDeg);
const _earthRadiusKm = 6371.0;

/// Qibla bearing in degrees [0, 360) from [latitude]/[longitude].
double calculateDirection(double latitude, double longitude) {
  final userLat = radians(latitude);
  final userLng = radians(longitude);

  final sinDiffLng = sin(_kaabaLng - userLng);
  final cosLatEnd = cos(_kaabaLat);
  final cosLatStart = cos(userLat);
  final sinLatEnd = sin(_kaabaLat);
  final sinLatStart = sin(userLat);
  final cosDiffLng = cos(_kaabaLng - userLng);

  final angleInRad = atan2(
    sinDiffLng * cosLatEnd,
    cosLatStart * sinLatEnd - sinLatStart * cosLatEnd * cosDiffLng,
  );

  return (angleInRad * 180 / pi + 360) % 360;
}

/// Great-circle distance to the Kaaba in kilometres.
double distanceToKaabaKm(double latitude, double longitude) {
  final lat1 = radians(latitude);
  final lat2 = _kaabaLat;
  final dLat = lat2 - lat1;
  final dLng = _kaabaLng - radians(longitude);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return _earthRadiusKm * c;
}

String formatDistanceKm(double km) {
  final n = km.round();
  final digits = n.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return '${buffer.toString()} KM';
}

String cardinalAbbreviation(double degrees) {
  const labels = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  final index = ((degrees % 360) / 45).round() % 8;
  return labels[index];
}

String formatQiblaDirectionLabel(double degrees) {
  final normalized = degrees % 360;
  return '${normalized.toStringAsFixed(1)}° ${cardinalAbbreviation(normalized)}';
}

/// True when device heading is within [toleranceDegrees] of the Qibla bearing.
bool isFacingQibla(
  double headingDegrees,
  double qiblaBearingDegrees, {
  double toleranceDegrees = 10,
}) {
  var diff = (headingDegrees - qiblaBearingDegrees).abs() % 360;
  if (diff > 180) diff = 360 - diff;
  return diff <= toleranceDegrees;
}

/// Fuses accelerometer + magnetometer (tilt-compensated heading).
class CompassSensorReader {
  CompassSensorReader({this.window = 20});

  final int window;
  final Vector3 _accelerometer = Vector3.zero();
  final Vector3 _magnetometer = Vector3.zero();
  final List<double> _headings = [];

  void updateAccelerometer(AccelerometerEvent event) {
    _accelerometer.setValues(event.x, event.y, event.z);
  }

  void updateMagnetometer(MagnetometerEvent event) {
    _magnetometer.setValues(event.x, event.y, event.z);
  }

  /// Device heading: 0° north, 90° east. Null if gravity vector is too weak.
  double? readHeadingDegrees() {
    if (_accelerometer.length2 < 0.25) {
      return null;
    }

    final matrix = motionSensors.getRotationMatrix(
      _accelerometer,
      _magnetometer,
    );
    final orientation = motionSensors.getOrientation(matrix);

    var headingDeg = orientation.x * 180 / pi;
    if (headingDeg < 0) {
      headingDeg += 360;
    }

    return _smooth(headingDeg);
  }

  double _smooth(double degrees) {
    _headings.add(degrees);
    if (_headings.length > window) {
      _headings.removeAt(0);
    }

    var sumX = 0.0;
    var sumY = 0.0;
    for (final deg in _headings) {
      final rad = radians(deg);
      sumX += cos(rad);
      sumY += sin(rad);
    }

    var avg = atan2(sumY, sumX) * 180 / pi;
    if (avg < 0) {
      avg += 360;
    }
    return avg;
  }
}

Future<bool> getMagnetometerAvailability() async {
  return motionSensors.isMagnetometerAvailable();
}

String getDirectionText(int angle) {
  if (angle >= 0 && angle < 45) {
    return 'North';
  }
  if (angle >= 45 && angle < 90) {
    return 'North-East';
  }
  if (angle >= 90 && angle < 135) {
    return 'East';
  }
  if (angle >= 135 && angle < 180) {
    return 'South-East';
  }
  if (angle >= 180 && angle < 225) {
    return 'South';
  }
  if (angle >= 225 && angle < 270) {
    return 'South-West';
  }
  if (angle >= 270 && angle < 315) {
    return 'West';
  }
  if (angle >= 315 && angle < 360) {
    return 'North-West';
  }

  switch (angle) {
    case 0:
      return 'North';
    case 45:
      return 'North-East';
    case 90:
      return 'East';
    case 135:
      return 'South-East';
    case 180:
      return 'South';
    case 225:
      return 'South-West';
    case 270:
      return 'West';
    case 315:
      return 'North-West';
    case 360:
      return 'North';
    default:
      return '';
  }
}
