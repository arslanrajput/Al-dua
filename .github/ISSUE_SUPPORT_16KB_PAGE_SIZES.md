# Support 16 KB page sizes

**Status:** Implemented (build config)  
**Priority:** High — Google Play blocking requirement  
**Labels:** `android`, `google-play`, `compliance`

## Google Play compatibility requirement

Starting **November 1, 2025**, all new apps and updates submitted to Google Play that target **Android 15 (API 35) and higher** must support **16 KB memory page sizes** on 64-bit devices.

Official documentation: [Support 16 KB page sizes](https://developer.android.com/guide/practices/page-sizes)

## What this project must satisfy

| Requirement | Target | This repo |
|-------------|--------|-----------|
| Android Gradle Plugin | 8.5.1+ | **8.11.1** (`android/settings.gradle`) |
| Gradle | 8.7+ | **8.14** (`gradle-wrapper.properties`) |
| NDK | r28+ (16 KB ELF alignment) | **`flutter.ndkVersion`** (28.2.x via Flutter SDK) |
| Native library packaging | 16 KB zip alignment | **`packaging.jniLibs.useLegacyPackaging = false`** (`android/app/build.gradle`) |
| `compileSdk` / `targetSdk` | 35+ (we use 36) | **36** |
| Flutter SDK | Recent stable with 16 KB engine | **3.41.x** |
| Plugin `.so` libraries | Rebuilt / updated deps | Run `flutter pub upgrade` before release |

## Implementation checklist

- [x] AGP 8.5.1 or higher
- [x] Set `ndkVersion flutter.ndkVersion` (NDK r28+)
- [x] `packaging { jniLibs { useLegacyPackaging = false } }`
- [x] Document requirement in `android/gradle.properties`
- [x] `targetSdkVersion 36` / `compileSdkVersion 36`
- [ ] Verify on Play Console after uploading AAB (App Bundle Explorer → 16 KB compliant)
- [ ] Optional: test on 16 KB emulator (`adb shell getconf PAGE_SIZE` → `16384`)
- [ ] Optional: `llvm-objdump -p libfoo.so \| grep LOAD` → align `2**14` or higher

## Verify before Play upload

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

1. Upload `build/app/outputs/bundle/release/app-release.aab` to Play Console (internal track).
2. Open **App bundle explorer** → confirm **16 KB page size** support is green.
3. If any native library fails, run `flutter pub outdated` / upgrade plugins with native code.

## Release signing

Play Store uploads require a release keystore:

- `android/key.properties` → `storeFile=../../upload-keystore.jks`
- Place `upload-keystore.jks` at the project root (not committed to git).

Without the keystore, release builds fall back to debug signing (local testing only).

## Related files

- `android/app/build.gradle`
- `android/gradle.properties`
- `android/settings.gradle`
