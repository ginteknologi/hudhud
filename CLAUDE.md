# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`masjid_app` (dir name `marbot`) — mosque app for Masjid An-Ni'mah. Riverpod + GoRouter + Firebase, Indonesian-only UI. Flutter **3.13.6** via FVM (`.fvm/fvm_config.json`) — much older than `../HabitFarm` and `../kkapps`; never copy dependency versions across those projects, and never invoke a global Flutter SDK here.

Dart package name is `masjid_app`, so every import is `package:masjid_app/...` regardless of directory name. Android `applicationId`/`namespace`: `com.masjid_app`.

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
- Long-lived exception: `lib/configs/remote_data.dart` (LAN dev IP) is only used by dead legacy services now — nothing live reads it.

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

## Legacy leftovers (dead on disk — delete, then drop the deps)

The GetX → Riverpod/GoRouter migration is complete for all reachable code (`fvm flutter analyze lib` = 0 errors, live graph imports neither `package:get/` nor `package:get_storage/`). What is left are ~107 unreachable files that still import GetX and therefore keep `get:` / `get_storage:` in `pubspec.yaml`:

- `lib/routes/**` (whole dir, incl. `isLogin_middleware.dart` — router now lives in `lib/core/router/`)
- `lib/bindings/**`, `lib/controllers/**`, `lib/service/**`, `lib/configs/{main_service,remote_data}.dart`, `lib/models/listayat_data.dart`
- per-feature `*_controller.dart` / `*_service.dart` under `lib/pages/**`
- dead pages: `lib/pages/quote/`, `lib/pages/kajian/`, `lib/pages/test/`, `lib/pages/alarm_solat/`, the old Quran readers (`lib/pages/quran/{halaman,halaman_madinah,halaman_tajwid,list_ayat,pengaturan}/`, `quran_page.dart`, `quran_controller.dart`, `quran_service.dart`), `lib/pages/dashboard/component/{waktu_solat,kajian_live_page}.dart`, `lib/pages/auth/logout/`, `lib/pages/splashscreen/splashscreen_controller.dart`, `lib/pages/sedekah/detail/detailsedekah_page copy.dart`

After deleting them: remove `get:` (pubspec:41) and `get_storage:` (pubspec:42), then `fvm flutter pub get` and re-run analyze.

## Gotchas

- `test/widget_test.dart` is untouched Flutter counter boilerplate (`find.text('0')`, `Icons.add`) against `MyApp`. `fvm flutter test` fails. There is no real test suite; verify changes by running the app.
- `easy_localization` is initialized in `main.dart` with `assets/lang/{en,en-US,id-ID}.json`, but those files contain only `{"title": ...}` and **zero `.tr()` calls exist in `lib/`**. UI strings are hardcoded Indonesian. Don't add l10n keys expecting them to be wired.
- Release builds need `android/key.properties` (referenced by `android/app/build.gradle` for `masjid-keystore.jks`); it is gitignored and not present, so `build apk --release` fails until recreated.
- Hardcoded Minio access/secret keys live in `lib/providers/akun_provider.dart` (copied from the old edit-akun controller) for the avatar upload — worth moving out of source, but it is the current contract.
- `main.dart` calls `InAppUpdate.performImmediateUpdate()` unconditionally on Android at startup.
- Flutter 3.13.6 predates `WidgetState`, `MaterialState` deprecations, and current `just_audio`/`geolocator` major versions — expect the pinned versions in `pubspec.lock` and don't upgrade casually.
- `lib/pages/dkm/dkm_page.dart` still has one inert tap (the old `/quote` route was never re-registered); `QuotePage` is dead code awaiting deletion.
