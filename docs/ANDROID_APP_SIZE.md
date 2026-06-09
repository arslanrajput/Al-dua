# Reducing APK / App Bundle size

## Why the APK looked huge (~255 MB)

A **universal release APK** includes native libraries for **every CPU architecture** (arm64, armeabi-v7a, x86_64). Flutter + plugins duplicate `.so` files per ABI.

**Google Play uses the AAB**, not the fat APK — Play delivers only the split the user’s device needs (often **~50–90 MB** download).

## What we changed

| Change | Effect |
|--------|--------|
| `ndk.abiFilters` arm only | Removes x86/x86_64 from release builds |
| `minifyEnabled` + `shrinkResources` | R8 shrinks Java/Kotlin + unused resources |
| `bundle { abi/density/language splits }` | Smaller Play downloads |
| `--split-per-abi` for APK | One APK per CPU (~⅓ of universal) |
| `--obfuscate --split-debug-info` | Smaller Dart snapshot; symbols kept for crashes |

## Build commands

```powershell
.\scripts\build_play_release.ps1
```

Or manually:

```powershell
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/app/outputs/symbols
```

Upload **`app-release.aab`** to Play Console.

For sideload testing use **`app-arm64-v8a-release.apk`** (most modern phones), not `app-release.apk`.

## Further reductions (optional)

- **`assets/fonts/jameel.ttf`** (~13 MB) — subset the font (only Urdu glyphs) with [fonttools](https://github.com/fonttools/fonttools) if Urdu is the only use.
- **Large Lottie JSON** — re-export from Lottie with lower complexity or use Rive/Lottie optimized.
- **`google_fonts`** — bundle only fonts you need as assets instead of many families in code.
- Run `flutter build appbundle --release --analyze-size` (Flutter 3.16+) for a size breakdown.

## Assets not in the app bundle

`assets/banner.png` and `assets/logo.png` at the repo root are **not** listed in `pubspec.yaml` and are not shipped unless you add them.
