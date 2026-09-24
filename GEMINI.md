# GEMINI.md

Petunjuk dan aturan untuk AI Assistant saat bekerja di repositori ini (`masjid_app` / `marbot`).

## Aturan Utama Flutter & Dart: SELALU GUNAKAN FVM

Proyek ini menggunakan **FVM (Flutter Version Management)** untuk mengelola versi Flutter SDK.

- **SELALU** gunakan perintah berawalan `fvm`:
  - `fvm flutter pub get`
  - `fvm flutter analyze`
  - `fvm flutter test`
  - `fvm flutter run`
  - `fvm flutter build <apk|appbundle|ios>`
  - `fvm dart ...`
- **JANGAN PERNAH** memanggil perintah `flutter` atau `dart` secara global langsung tanpa `fvm`.
- Konfigurasi FVM berada di `.fvmrc` dan `.fvm/fvm_config.json`.
- SDK Flutter terkait berada di link `.fvm/flutter_sdk` (atau `.fvm/versions/stable`).
