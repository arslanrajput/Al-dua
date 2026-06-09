# Builds Play Store AAB + release APK. Requires key/alDua-keystore.jks and credentials.
param(
    [string]$StorePassword,
    [string]$KeyPassword,
    [string]$KeyAlias
)

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$keystore = Join-Path (Get-Location) "key\alDua-keystore.jks"
if (-not (Test-Path $keystore)) {
    Write-Error "Missing key\alDua-keystore.jks - add your upload keystore first."
}

$localProps = Join-Path (Get-Location) "key\signing.local.properties"
if ($StorePassword) { $env:ALDUA_STORE_PASSWORD = $StorePassword }
if ($KeyPassword) { $env:ALDUA_KEY_PASSWORD = $KeyPassword }
if ($KeyAlias) { $env:ALDUA_KEY_ALIAS = $KeyAlias }

$hasCreds = $env:ALDUA_STORE_PASSWORD -or (Test-Path $localProps)
if (-not $hasCreds) {
    Write-Host "No credentials found."
    Write-Host "  Option A: Create key\signing.local.properties (see key\README.md)"
    Write-Host "  Option B: Run: .\scripts\build_play_release.ps1 -StorePassword '...' -KeyPassword '...' -KeyAlias 'upload'"
    exit 1
}

$symbolDir = "build\app\outputs\symbols"
$dartFlags = @(
    "--obfuscate",
    "--split-debug-info=$symbolDir",
    "--target-platform", "android-arm,android-arm64"
)

Write-Host "Building release app bundle (R8 + ARM-only + Dart obfuscate)..."
flutter build appbundle --release @dartFlags
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Building ARM APKs..."
flutter build apk --release --split-per-abi @dartFlags
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$outDir = Join-Path (Get-Location) "release\play-store"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
Copy-Item "build\app\outputs\bundle\release\app-release.aab" (Join-Path $outDir "al-dua-release.aab") -Force

$arm64Apk = Get-ChildItem "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" -ErrorAction SilentlyContinue
if ($arm64Apk) {
    Copy-Item $arm64Apk.FullName (Join-Path $outDir "al-dua-arm64-v8a-release.apk") -Force
}

Write-Host ""
Write-Host "Done. Play Store upload (users get smallest split per device):"
Write-Host "  $outDir\al-dua-release.aab"
if ($arm64Apk) {
    Write-Host "Test APK (arm64 only, about one-third size of fat APK):"
    Write-Host "  $outDir\al-dua-arm64-v8a-release.apk"
}
Write-Host "Debug symbols: $symbolDir"
