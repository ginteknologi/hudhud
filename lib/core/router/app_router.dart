import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/pages/akun/akun_page.dart';
import 'package:masjid_app/pages/akun/edit/edit_akun_page.dart';
import 'package:masjid_app/pages/akun/riwayat/riwayat_page.dart';
import 'package:masjid_app/pages/artikel/artikel_page.dart';
import 'package:masjid_app/pages/artikel/detail/detail_artikel_page.dart';
import 'package:masjid_app/pages/auth/auth_page.dart';
import 'package:masjid_app/pages/doa/content/doa_content_page.dart';
import 'package:masjid_app/pages/doa/detail/detail_doa_page.dart';
import 'package:masjid_app/pages/doa/doa_page.dart';
import 'package:masjid_app/pages/pengaturan/pengaturan_umum_page.dart';
import 'package:masjid_app/pages/dzikir/dzikir_page.dart';
import 'package:masjid_app/pages/hadits/bab/hadits_bab_page.dart';
import 'package:masjid_app/pages/hadits/hadits_page.dart';
import 'package:masjid_app/pages/hadits/list/hadits_list_page.dart';
import 'package:masjid_app/pages/hadits/search/hadits_search_page.dart';
import 'package:masjid_app/pages/hadits/tema/hadits_tema_page.dart';
import 'package:masjid_app/pages/home/home_page.dart';
import 'package:masjid_app/pages/jadwal_imsakiah/jadwal_imsakiah_page.dart';
import 'package:masjid_app/pages/masjid_terdekat/cari_masjid_page.dart';
import 'package:masjid_app/pages/kiblat/kiblat_page.dart';
import 'package:masjid_app/pages/notifikasi/detail/detail_notifikasi_page.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_page.dart';
import 'package:masjid_app/pages/onboarding/onboard_page.dart';
import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/halaman_madinah/halaman_quran_madinah_page.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/halaman_quran_tajwid_page.dart';
import 'package:masjid_app/pages/quran/list_ayat/detail/detail_quran_page.dart';
import 'package:masjid_app/pages/quran/list_ayat/list_ayat_quran_page.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/pages/quran/pengaturan/alquran_pengaturan_page.dart';
import 'package:masjid_app/pages/splashscreen/splashscreen_page.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/providers/auth_provider.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String home = '/';
  static const String quran = '/quran';
  // Al-Qur'an readers. Query params mirror the legacy GetX routes:
  //   /quran/perayat?id=1&nama_surah=Al-Fatihah&bookmarks=true
  //   /quran/detail/:id?nama_surah=Al-Fatihah
  static const String quranPerAyat = '/quran/perayat';
  static const String quranDetailAyat = '/quran/detail/:id';
  static const String quranPage = '/quran/perpage';
  static const String quranPageMadinah = '/quran/perpage/madinah';
  static const String quranPageTajwid = '/quran/perpage/tajwid';
  static const String quranPengaturan = '/quran/pengaturan';
  static const String doa = '/doa';
  static const String doaDetail = '/doa/:id';
  static const String doaContent = '/doa/:id/:content';
  static const String dzikir = '/dzikir';
  static const String hadits = '/hadits';
  // Tiga level: /hadits → /hadits/bab/:id → /hadits/list/:id
  // Reader menerima scope lewat query param: ?bab= / ?mulai= / ?akhir=
  static const String haditsListRoute = '/hadits/list/:id';
  static const String haditsBab = '/hadits/bab/:id';
  static const String haditsSearch = '/hadits/search';
  static const String haditsTema = '/hadits/tema';
  static const String haditsTemaDetail = '/hadits/tema/:id';
  static const String kiblat = '/kiblat';
  static const String artikel = '/artikel';
  static const String artikelDetail = '/artikel/:id';
  static const String notifikasi = '/notifikasi';
  static const String notifikasiDetail = '/notifikasi/detail/:id';
  static const String onboarding = '/onboard';
  static const String jadwalImsakiah = '/jadwal-imsakiah';
  static const String cariMasjid = '/cari-masjid';
  static const String profile = '/profile';
  static const String profileEdit = '/akun/edit';
  static const String profileRiwayat = '/akun/riwayat';
  static const String pengaturanUmum = '/pengaturan/umum';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isAuthenticated = authState.valueOrNull != null;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isAuth = state.matchedLocation == AppRoutes.auth;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      if (isLoading) return null;

      // 1. Splash screen: biarkan SplashscreenPage tampil dulu
      if (isSplash) return null;

      // 2. Jika user baru dan belum menyelesaikan onboarding
      final hasCompletedOnboarding = PreferencesService.onboardingCompleted;
      if (!hasCompletedOnboarding) {
        return isOnboarding ? null : AppRoutes.onboarding;
      }

      // 3. Jika sudah menyelesaikan onboarding tapi mencoba buka /onboard
      if (isOnboarding) {
        return isAuthenticated ? AppRoutes.home : AppRoutes.auth;
      }

      // 4. Jika belum login dan bukan halaman auth
      if (!isAuthenticated && !isAuth) {
        return AppRoutes.auth;
      }

      // 5. Jika sudah login dan masih di halaman auth
      if (isAuthenticated && isAuth) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashscreenPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.quran,
        builder: (context, state) => AlquranPage(),
      ),
      GoRoute(
        path: AppRoutes.quranPerAyat,
        builder: (context, state) => const ListAyatQuranPage(),
      ),
      GoRoute(
        path: AppRoutes.quranDetailAyat,
        builder: (context, state) => const DetailAyatQuranPage(),
      ),
      GoRoute(
        path: AppRoutes.quranPageMadinah,
        builder: (context, state) => const HalamanQuranMadinahPage(),
      ),
      GoRoute(
        path: AppRoutes.quranPageTajwid,
        builder: (context, state) => const HalamanQuranTajwidPage(),
      ),
      GoRoute(
        path: AppRoutes.quranPage,
        builder: (context, state) => const HalamanQuranPage(),
      ),
      GoRoute(
        path: AppRoutes.quranPengaturan,
        builder: (context, state) => const AlquranPengaturanPage(),
      ),
      GoRoute(
        path: AppRoutes.doa,
        builder: (context, state) => const DoaPage(),
      ),
      GoRoute(
        path: AppRoutes.doaDetail,
        builder: (context, state) => const DetailDoaPage(),
      ),
      GoRoute(
        path: AppRoutes.doaContent,
        builder: (context, state) => const ContentDoaPage(),
      ),
      GoRoute(
        path: AppRoutes.dzikir,
        builder: (context, state) => const DzikirPage(),
      ),
      GoRoute(
        path: AppRoutes.hadits,
        builder: (context, state) => HaditsPage(),
      ),
      // v2 — List hadits langsung dengan pagination
      GoRoute(
        path: AppRoutes.haditsListRoute,
        builder: (context, state) => const HaditsListPage(),
      ),
      GoRoute(
        path: AppRoutes.haditsBab,
        builder: (context, state) => const HaditsBabPage(),
      ),
      GoRoute(
        path: AppRoutes.haditsSearch,
        builder: (context, state) => const HaditsSearchPage(),
      ),
      GoRoute(
        path: AppRoutes.haditsTema,
        builder: (context, state) => const HaditsTemaPage(),
      ),
      GoRoute(
        path: AppRoutes.haditsTemaDetail,
        builder: (context, state) => const HaditsTemaPage(),
      ),
      GoRoute(
        path: AppRoutes.kiblat,
        builder: (context, state) => KiblatPage(),
      ),
      GoRoute(
        path: AppRoutes.cariMasjid,
        builder: (context, state) => const CariMasjidPage(),
      ),
      GoRoute(
        path: AppRoutes.artikel,
        builder: (context, state) => ArtikelPage(),
      ),
      GoRoute(
        path: AppRoutes.artikelDetail,
        builder: (context, state) => DetailArtikelPage(),
      ),
      GoRoute(
        path: AppRoutes.notifikasi,
        builder: (context, state) => const NotifikasiPage(),
      ),
      GoRoute(
        path: AppRoutes.notifikasiDetail,
        builder: (context, state) => const DetailNotifikasiPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => OnboardPage(),
      ),
      GoRoute(
        path: AppRoutes.jadwalImsakiah,
        builder: (context, state) => const JadwalImsakiahPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const AkunPage(),
      ),
      GoRoute(
        path: AppRoutes.pengaturanUmum,
        builder: (context, state) => const PengaturanUmumPage(),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        builder: (context, state) => const EditAkunPage(),
      ),
      GoRoute(
        path: AppRoutes.profileRiwayat,
        builder: (context, state) => const RiwayatPage(),
      ),
    ],
  );
});
