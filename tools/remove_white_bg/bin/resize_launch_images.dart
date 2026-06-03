import 'dart:io';

import 'package:image/image.dart' as img;

/// Generates iOS LaunchImage 1x/2x/3x from the app logo PNG.
void main(List<String> args) {
  final srcPath = args.isNotEmpty
      ? args.first
      : 'assets/images/core/png/app_logo.png';
  final outDir = args.length > 1
      ? args[1]
      : 'ios/Runner/Assets.xcassets/LaunchImage.imageset';

  final bytes = File(srcPath).readAsBytesSync();
  final source = img.decodeImage(bytes);
  if (source == null) {
    stderr.writeln('Failed to decode $srcPath');
    exit(1);
  }

  const baseWidth = 200;
  final outputs = <String, int>{
    '$outDir/LaunchImage.png': baseWidth,
    '$outDir/LaunchImage@2x.png': baseWidth * 2,
    '$outDir/LaunchImage@3x.png': baseWidth * 3,
  };

  for (final entry in outputs.entries) {
    final resized = img.copyResize(source, width: entry.value);
    File(entry.key).writeAsBytesSync(img.encodePng(resized));
    stdout.writeln('Wrote ${entry.key} (${entry.value}px wide)');
  }
}
