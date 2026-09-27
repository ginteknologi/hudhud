# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

**Hudhud** (package `masjid_app`, directory `marbot`) — Islamic daily companion app (Quran, Prayer times, Hadits, Doa, Dzikir) with an international vision, rebranded from the legacy single-mosque app. Riverpod + GoRouter + Firebase. Flutter managed via FVM (`.fvm/fvm_config.json`, `.fvmrc`) — **ALWAYS use FVM (`fvm flutter ...`, `fvm dart ...`)**; never invoke a global Flutter SDK directly here.

Dart package name is `masjid_app`, so every import is `package:masjid_app/...` regardless of directory name. Android `applicationId`/`namespace`: `com.example.masjid_app` (`android/app/build.gradle.kts`).

## Commands

```bash
cd marbot
fvm flutter pub get
fvm flutter run
fvm flutter analyze              # 0 errors; clean lint status
fvm flutter test                 # 26/26 unit tests passing
fvm flutter build apk --release  # needs android/key.properties
```

## Architecture

### State + navigation (current stack)
- **Riverpod** `flutter_riverpod` — `ProviderScope` in `main.dart`. Pages are `ConsumerWidget` / `ConsumerStatefulWidget`; local widget state stays in `State` (controllers, `setState`), server state lives in providers.
- **GoRouter** `go_router` — `MaterialApp.router`, `routerProvider` in `lib/core/router/app_router.dart`. All routes are **flat** (no nested children), so a push never needs a parent page to render a child. `AppRoutes` holds every path as a `static const String`; params are added with `.replaceFirst(':id', value)` or query params.
- **Bottom Navigation**: 3 Core Tabs (`HomePage`):
  1. `DashboardPage` (Beranda: prayer countdown, Quran quick jump, 8-menu grid, featured articles & daily doa)
  2. `AlquranPage` (Al-Qur'an: Surah, Juz, Mushaf readers)
  3. `AkunPage` (`lib/pages/akun/akun_page.dart`: Profile, general settings, Quran preferences, app sharing, app version, logout)
- Auth gate: `redirect` in `routerProvider` watches `authNotifierProvider` (`lib/providers/auth_provider.dart`) and the `PreferencesService.onboardingCompleted` flag; splash `/splash` and `/onboard` are always allowed.

### Providers (`lib/providers/`)
`api_providers.dart` exposes `apiClientProvider`; nearly every other provider is a `FutureProvider` / `FutureProvider.family` that watches it and returns `[]` or an empty model on failure (pages then render placeholders). Family params that need value equality are small classes with `==`/`hashCode` (e.g. `DoaListParams`, `HaditsBabParams`).

### Network (`lib/core/network/`)
- `ApiClient` — Dio wrapper (`get`/`post`, optional `queryParameters` and `fromJson`), bearer token from `PreferencesService.token`. Returns `ApiResponse<T>`; throws the `AppException` hierarchy.
- `ApiEndpoints` — every path as a `static const String`; `baseUrl` is `String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.masjidannimah.id/api/v1')`.
- Active Endpoint families: `/quran/*`, `/doa/*`, `/hadits/*`, `/artikel/*`, `/notif`, `/event`, `/waktusolat`.
- **Cleaned/Deleted Endpoints**: Legacy live stream (`/live`), kajian live/slider, sahabat muazin, invoice/transaksi order (`/transaksi/order`), sedekah, and ruangan endpoints have been removed.

### Storage (`lib/core/storage/`)
- `preferences_service.dart`: `shared_preferences` facade for auth token, onboarding status, and general preferences.
- `bookmark_storage.dart`: Quran bookmark and last-read persistence across Ayat and Mushaf readers (Indonesia, Madinah, Tajwid).

### UI & Theme (Hudhud Palette)
- **Theme Concept**: Eurasian Hoopoe (Burung Hudhud) color system:
  - `AppColors.appPrimary` / `kTileAccent`: `#D06A4C` (Hudhud Warm Terracotta / Cinnamon)
  - `AppColors.appPrimary2` / `kTileGold`: `#ECA843` (Crest Amber Gold)
  - `AppColors.surface` / `kTilePageBg`: `#FBF7F2` (Warm Sand Off-White)
  - `AppColors.textDark` / `kTileTextDark`: `#2B2523` (Deep Charcoal)
  - Gradient Headers: `[Color(0xFFD06A4C), Color(0xFFB85639), Color(0xFF8C3B24)]`
- `lib/theme.dart`: Centralized `lightTheme` and `darkTheme`.
- `lib/components/partial/settings_tile.dart`: Shared tile and card widgets for settings and profile screens.

## Testing & Quality Assurance
- Automated tests are in `test/`:
  - `app_settings_test.dart`: Adzan scheduler & prayer notification settings
  - `hadits_models_test.dart`: Hadits data parsing & bookmark storage
  - `kiblat_test.dart`: Qibla bearing calculation & distance math
  - `location_test.dart`: Default city location ('Jakarta') & GPS fallback
  - `pagination_state_test.dart`: Generic pagination logic
  - `quran_models_test.dart`: Surah and Juz models validation
- Run `fvm flutter test` before pushing to ensure all 26 tests pass.
- Run `fvm flutter analyze` to ensure zero compilation or analyzer errors.
