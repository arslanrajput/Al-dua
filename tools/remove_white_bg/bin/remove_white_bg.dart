import 'dart:io';

import 'package:image/image.dart' as img;

/// Makes near-white pixels transparent (keeps the green icon).
void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln('Usage: dart run remove_white_bg.dart <input.png> <output1.png> [output2.png ...]');
    exit(1);
  }

  final inputPath = args.first;
  final bytes = File(inputPath).readAsBytesSync();
  final image = img.decodeImage(bytes);
  if (image == null) {
    stderr.writeln('Failed to decode: $inputPath');
    exit(1);
  }

  const threshold = 248;
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final p = image.getPixel(x, y);
      final r = p.r.toInt();
      final g = p.g.toInt();
      final b = p.b.toInt();

      if (r >= threshold && g >= threshold && b >= threshold) {
        image.setPixelRgba(x, y, r, g, b, 0);
      } else if (r > 230 && g > 230 && b > 230) {
        final whiteness = [r, g, b].reduce((a, c) => a < c ? a : c);
        final alpha = ((255 * (threshold - whiteness) / 18).clamp(0, 255)).round();
        image.setPixelRgba(x, y, r, g, b, alpha);
      }
    }
  }

  final png = img.encodePng(image);
  for (final out in args.skip(1)) {
    File(out).writeAsBytesSync(png);
    stdout.writeln('Wrote $out (${image.width}x${image.height})');
  }
}
