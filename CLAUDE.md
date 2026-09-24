# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`masjid_app` (dir name `marbot`) — mosque app for Masjid An-Ni'mah. Riverpod + GoRouter + Firebase, Indonesian-only UI. Flutter via FVM (`.fvm/fvm_config.json`, `.fvmrc`) — **ALWAYS use FVM (`fvm flutter ...`, `fvm dart ...`)**; never invoke a global Flutter SDK directly here.

Dart package name is `masjid_app`, so every import is `package:masjid_app/...` regardless of directory name. Android `applicationId`/`namespace`: `com.example.masjid_app` (`android/app/build.gradle.kts:9,21`).

## Commands

```bash
cd marbot
fvm flutter pub get
fvm flutter run
fvm flutter analyze              # 0 errors; ~54 infos are pre-existing lints
fvm flutter test                 # currently FAILS — see Gotchas
fvm flutter build apk --release  # needs android/key.properties, absent
```

No codegen, no lints beyond `flutter_lints` defaults (`analysis_options.yaml` untouched).

## Architecture

### State + navigation (current stack)
- **Riverpod** `flutter_riverpod` — `ProviderScope` in `main.dart`. Pages are `ConsumerWidget` / `ConsumerStatefulWidget`; local widget state stays in `State` (controllers, `setState`), server state lives in providers.
- **GoRouter** `go_router` — `MaterialApp.router`, `routerProvider` in `lib/core/router/app_router.dart`. All routes are **flat** (no nested children), so a push never needs a parent page to render a child. `AppRoutes` holds every path as a `static const String`; params are added with `.replaceFirst(':id', value)` or `.replaceFirst(':id/:content', ...)`, list/model objects are passed via `extra`.
- Auth gate: `redirect` in `routerProvider` watches `authNotifierProvider` (`lib/providers/auth_provider.dart`) and the `PreferencesService.onboardingCompleted` flag; splash `/splash` and `/onboard` are always allowed.

### Providers (`lib/providers/`)
`api_providers.dart` exposes `apiClientProvider`; nearly every other provider is a `FutureProvider` / `FutureProvider.family` that watches it and returns `[]` or an empty model on failure (pages then render placeholders — most catch blocks deliberately swallow). Family params that need value equality are small classes with `==`/`hashCode` (e.g. `DoaListParams`, `HaditsBabParams`). Mutation flows use `StateNotifierProvider` (`bookingRuanganProvider`, `sedekahOrderProvider`, `alquranBookmarkProvider`, `authNotifierProvider`).

Pages are `lib/pages/<feature>/`; `<feature>_controller.dart` / `_service.dart` files there are dead leftovers of the GetX era (see **Legacy leftovers**).

### Network (`lib/core/network/`)
- `ApiClient` — Dio wrapper (`get`/`post`, optional `queryParameters` and `fromJson`), bearer token from `PreferencesService.token`. Returns `ApiResponse<T>`; throws the `AppException` hierarchy.
- `ApiEndpoints` — every path as a `static const String`; `baseUrl` is `String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.masjidannimah.id/api/v1')`, so an override goes on the run/build command, not in source.
- Endpoint families: `/quran/{surah,juz,random-surah}`, `/doa/{list,category,detail,dzikir}`, `/hadits/{detail,bab}`, `/artikel`, `/kajian/{list,slider,muadzin,kaji-live}`, `/campaign`, `/live`, `/event`, `/ruangan/booking`, `/notif`, `/transaksi/*`, `/profile`, `/fcm`, `/dkm`, `/waktusolat`.
- The old LAN-dev-IP switch (`lib/configs/remote_data.dart`) was deleted with the rest of the GetX layer.

### Storage (`lib/core/storage/preferences_service.dart`)
`shared_preferences` behind one static facade. Keys: `is_login`, `user_data` (user JSON), `jwt_token`, `fcm_token`, `onboarding_completed`, `last_read_ayat`, `last_read_halaman`, plus generic `getString`/`setString`/`remove` for per-feature transient values (sedekah payment flow keys `inputDataPembayaran`, `dataInvoice`). `clearAuth()` on logout.

### Adzan / background
`lib/configs/firebase_message_setup.dart` holds all of it: FCM init (`DefaultFirebaseOptions.android` only), foreground/background handlers, local-notification channels, and `onStartPlay` — an Android `flutter_background_service` isolate polling every 60s, comparing `DateTime.now()` HHmm against prayer times, firing a full-screen `adzan` raw-resource sound notification. `Scheduling()` (which starts it) is commented out in `initFirebase`, so this path is currently inert. `SetupFirebase.sendnotif` is the manual local-notification entry point.

Android side needs the manifest permissions already present: `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, `SCHEDULE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED`, `ACCESS_NOTIFICATION_POLICY`.

### UI layer
- `lib/theme.dart`: `AppColors` (primary `#048C7C`) + `lightTheme`/`darkTheme`. `MyApp` sets `themeMode: ThemeMode.light` — the dark theme is built but never applied.
- `lib/fonts.dart`: `FontListV2.*` text styles used everywhere; `google_fonts` + bundled `DMSerifDisplay`/`Roboto` (`assets/fonts`).
- `lib/components/`: `button/` (ButtonVariant is the button entry point), `input/`, `layout/` (`AppBarWSWidget.getAppbarWidget`, custom bottom bar, dialogs, modals), `partial/` (list cards), plus `AppUi.loading(noConnection:, onReload:)` for the standard loading/offline state and `keepAlive.dart` for `ScrollablePositionedList`.
- Use `Theme.of(context).textTheme` — `context.textTheme` was a GetX extension and no longer resolves.
- Assets are pre-declared per folder in `pubspec.yaml` — a new asset folder must be added there.

## Migration history (done — don't reintroduce GetX)

The GetX → Riverpod/GoRouter migration is complete and the legacy code is gone: `lib/routes/**`, `lib/bindings/**`, `lib/controllers/**`, `lib/service/**`, `lib/configs/{main_service,remote_data}.dart`, `lib/models/listayat_data.dart`, every `*_controller.dart`/`*_service.dart` under `lib/pages/**`, and the dead quote/kajian/test/alarm_solat/logout pages were all deleted, and `get:`/`get_storage:` are out of `pubspec.yaml` (commits `ff52346`, `25d1b9e` on branch `migrasi-getx-ke-riverpod`). Seluruh pembaca Al-Qur'an (Per Ayat `lib/pages/quran/list_ayat/`, Mushaf Indonesia `lib/pages/quran/halaman/`, Mushaf Madinah `lib/pages/quran/halaman_madinah/`, Mushaf Tajwid `lib/pages/quran/halaman_tajwid/`, dan Pengaturan `lib/pages/quran/pengaturan/`) telah sepenuhnya di-restore dan di-port ke Riverpod + GoRouter tanpa GetX/GetStorage; `ApiEndpoints.baseUrl` (or `--dart-define=API_BASE_URL=...`) is the single backend switch.

## Gotchas

- `test/widget_test.dart` is untouched Flutter counter boilerplate (`find.text('0')`, `Icons.add`) against `MyApp`. `fvm flutter test` fails. There is no real test suite; verify changes by running the app.
- `easy_localization` is initialized in `main.dart` with `assets/lang/{en,en-US,id-ID}.json`, but those files contain only `{"title": ...}` and **zero `.tr()` calls exist in `lib/`**. UI strings are hardcoded Indonesian. Don't add l10n keys expecting them to be wired.
- Release builds need `android/key.properties` (referenced by `android/app/build.gradle` for `masjid-keystore.jks`); it is gitignored and not present, so `build apk --release` fails until recreated.
- Hardcoded Minio access/secret keys live in `lib/providers/akun_provider.dart` (copied from the old edit-akun controller) for the avatar upload — worth moving out of source, but it is the current contract.
- `main.dart` calls `InAppUpdate.performImmediateUpdate()` unconditionally on Android at startup.
- Flutter 3.13.6 predates `WidgetState`, `MaterialState` deprecations, and current `just_audio`/`geolocator` major versions — expect the pinned versions in `pubspec.lock` and don't upgrade casually.
- `lib/pages/dkm/dkm_page.dart:193` has one inert tap — the old `/quote` page was deleted with the GetX layer and no replacement route exists (`TODO(migrasi)` in the file).
