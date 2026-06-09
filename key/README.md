# Release signing

## Files

| File | Committed? | Purpose |
|------|------------|---------|
| `alDua-keystore.jks` | No (gitignored) | Upload keystore for Play Store |
| `signing.local.properties` | No (gitignored) | Your real passwords & alias |
| `signing.local.properties.example` | Yes | Template |

## Setup (one time)

1. Keep `alDua-keystore.jks` in this folder.
2. Copy the example and fill in the passwords you used in Android Studio:

```powershell
copy key\signing.local.properties.example key\signing.local.properties
```

Edit `key\signing.local.properties`:

```properties
storePassword=<keystore-password>
keyPassword=<key-password>
keyAlias=<alias-from-android-studio>
```

3. Build release artifacts:

```powershell
flutter build appbundle --release
flutter build apk --release
```

Outputs:

- `build\app\outputs\bundle\release\app-release.aab` → Play Console
- `build\app\outputs\flutter-apk\app-release.apk` → testing

## Alternative: environment variables

```powershell
$env:ALDUA_STORE_PASSWORD = "your-store-password"
$env:ALDUA_KEY_PASSWORD = "your-key-password"
$env:ALDUA_KEY_ALIAS = "your-alias"
flutter build appbundle --release
```
