# AGENTS.md

## Repository Guidelines & Instructions

### Project Identity & Vision
- **App Name**: **Hudhud** (`masjid_app` in pubspec / namespace).
- **Concept**: Islamic daily companion app (Quran, Adzan, Hadits, Doa, Dzikir) with an international vision, moving away from localized single-mosque branding.
- **Visual Identity**: Inspired by the Eurasian Hoopoe (Burung Hudhud) — Warm Terracotta / Cinnamon (`#D06A4C`), Crest Amber Gold (`#ECA843`), Warm Sand Off-White (`#FBF7F2`), and Deep Charcoal (`#2B2523`).

### Flutter Version Management (FVM)
- **Always use FVM**: Every Flutter and Dart CLI operation must be invoked with `fvm`.
  - Use `fvm flutter ...` (e.g. `fvm flutter pub get`, `fvm flutter run`, `fvm flutter analyze`, `fvm flutter test`).
  - Use `fvm dart ...` for Dart commands.
- **Never invoke global Flutter or Dart directly**.
- FVM configuration is in `.fvmrc` and `.fvm/fvm_config.json`.

### Architecture & Standards
- **State Management**: Riverpod (`flutter_riverpod`).
- **Navigation**: Flat routes with GoRouter (`go_router`) in `lib/core/router/app_router.dart`.
- **Bottom Navigation**: 3 Core Tabs — `[Beranda, Al-Qur'an, Akun]`.
- **Quality Gates**: Every change must pass `fvm flutter test` (26 unit tests) and `fvm flutter analyze` with zero errors.
- **Storage**: Clean storage services under `lib/core/storage/` (e.g. `bookmark_storage.dart`, `preferences_service.dart`).
