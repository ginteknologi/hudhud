import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/pages/akun/akun_page.dart';
import 'package:masjid_app/pages/akun/edit/edit_akun_page.dart';
import 'package:masjid_app/pages/akun/riwayat/riwayat_page.dart';
import 'package:masjid_app/pages/artikel/artikel_page.dart';
import 'package:masjid_app/pages/artikel/detail/detail_artikel_page.dart';
import 'package:masjid_app/pages/auth/auth_page.dart';
import 'package:masjid_app/pages/dkm/dkm_page.dart';
import 'package:masjid_app/pages/doa/content/doa_content_page.dart';
import 'package:masjid_app/pages/doa/detail/detail_doa_page.dart';
import 'package:masjid_app/pages/doa/doa_page.dart';
import 'package:masjid_app/pages/pengaturan/pengaturan_umum_page.dart';
import 'package:masjid_app/pages/dzikir/dzikir_page.dart';
import 'package:masjid_app/pages/hadits/bab/bab_hadits_page.dart';
import 'package:masjid_app/pages/hadits/content/content_hadits_page.dart';
import 'package:masjid_app/pages/hadits/detail/detail_hadits_page.dart';
import 'package:masjid_app/pages/hadits/hadits_page.dart';
import 'package:masjid_app/pages/hadits/list/hadits_list_page.dart';
import 'package:masjid_app/pages/home/home_page.dart';
import 'package:masjid_app/pages/kalenderdzulhijjah/kalenderdzulhijjah_page.dart';
import 'package:masjid_app/pages/kajian/detail/kajian_detail_page.dart';
import 'package:masjid_app/pages/kajian/kajian_list_page.dart';
import 'package:masjid_app/pages/kiblat/kiblat_page.dart';
import 'package:masjid_app/pages/muazin/muazin_page.dart';
import 'package:masjid_app/pages/notifikasi/detail/detail_notifikasi_page.dart';
import 'package:masjid_app/pages/notifikasi/invoice/invoice_page.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_page.dart';
import 'package:masjid_app/pages/onboarding/onboard_page.dart';
import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/halaman_madinah/halaman_quran_madinah_page.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/halaman_quran_tajwid_page.dart';
import 'package:masjid_app/pages/quran/list_ayat/detail/detail_quran_page.dart';
import 'package:masjid_app/pages/quran/list_ayat/list_ayat_quran_page.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/pages/quran/pengaturan/alquran_pengaturan_page.dart';
import 'package:masjid_app/pages/ruangan/booking/booking_ruangan_page.dart';
import 'package:masjid_app/pages/ruangan/jadwal/jadwal_ruangan_page.dart';
import 'package:masjid_app/pages/ruangan/ruangan_page.dart';
import 'package:masjid_app/pages/sedekah/detail/detailsedekah_page.dart';
import 'package:masjid_app/pages/sedekah/sedekah_page.dart';
import 'package:masjid_app/pages/sedekah/transaksi/instruksi/instruksi_page.dart';
import 'package:masjid_app/pages/sedekah/transaksi/metode/metode_transaksi_page.dart';
import 'package:masjid_app/pages/sedekah/transaksi/paymentEwallet/payment_transaksi_page.dart';
import 'package:masjid_app/pages/sedekah/transaksi/status/status_sedekah_page.dart';
import 'package:masjid_app/pages/sedekah/transaksi/transaksi_sedekah_page.dart';
import 'package:masjid_app/pages/splashscreen/splashscreen_page.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/kajian_provider.dart';

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
  static const String haditsListRoute = '/hadits/list/:id'; // v2 — langsung ke list hadits
  static const String haditsBab = '/hadits/bab/:id';
  static const String haditsDetail = '/hadits/:id';
  static const String haditsContent = '/hadits/:id/:content';
  static const String sedekah = '/sedekah';
  static const String sedekahDetail = '/sedekah/:id';
  static const String sedekahTransaksi = '/sedekah/:id/transaksi';
  static const String sedekahMetode = '/sedekah/:id/transaksi/metode';
  static const String sedekahPayment = '/sedekah/:id/transaksi/payment';
  static const String sedekahStatus = '/sedekah/:id/transaksi/status';
  static const String sedekahInstruksi = '/sedekah/transaksi/intruksi';
  static const String kiblat = '/kiblat';
  static const String ruangan = '/ruangan';
  static const String ruanganJadwal = '/ruangan/jadwal';
  static const String ruanganBooking = '/ruangan/booking';
  static const String dkm = '/dkm';
  static const String muazin = '/muazin';
  static const String kajianLive = '/kajian/live';
  static const String kajianTafsir = '/kajian/tafsir';
  static const String kajianDetail = '/kajian/detail/:id';
  static const String artikel = '/artikel';
  static const String artikelDetail = '/artikel/:id';
  static const String notifikasi = '/notifikasi';
  static const String notifikasiDetail = '/notifikasi/detail/:id';
  static const String notifikasiInvoice = '/notifikasi/detail/invoice/:invoice';
  static const String onboarding = '/onboard';
  static const String kalenderDzulhijjah = '/kalenderdzulhijjah';
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

      if (isLoading) return null;

      if (isSplash) {
        return isAuthenticated ? AppRoutes.home : AppRoutes.auth;
      }

      if (!isAuthenticated && !isAuth && !isSplash) {
        return AppRoutes.auth;
      }

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
        builder: (context, state) => const BabHaditsPage(),
      ),
      GoRoute(
        path: AppRoutes.haditsDetail,
        builder: (context, state) => const DetailHaditsPage(),
      ),
      GoRoute(
        path: AppRoutes.haditsContent,
        builder: (context, state) => const ContentHaditsPage(),
      ),
      GoRoute(
        path: AppRoutes.sedekah,
        builder: (context, state) => SedekahPage(),
      ),
      GoRoute(
        path: AppRoutes.sedekahDetail,
        builder: (context, state) => const DetailSedekahPage(),
      ),
      GoRoute(
        path: AppRoutes.sedekahTransaksi,
        builder: (context, state) => const TransaksiSedekahPage(),
      ),
      GoRoute(
        path: AppRoutes.sedekahMetode,
        builder: (context, state) => const MetodeTransaksiSedekahPage(),
      ),
      GoRoute(
        path: AppRoutes.sedekahPayment,
        builder: (context, state) => const PaymentTransaksiSedekahPage(),
      ),
      GoRoute(
        path: AppRoutes.sedekahStatus,
        builder: (context, state) => const StatusTransaksiSedekahPage(),
      ),
      GoRoute(
        path: AppRoutes.sedekahInstruksi,
        builder: (context, state) => const InstruksiPage(),
      ),
      GoRoute(
        path: AppRoutes.kiblat,
        builder: (context, state) => KiblatPage(),
      ),
      GoRoute(
        path: AppRoutes.ruangan,
        builder: (context, state) => const RuanganPage(),
      ),
      GoRoute(
        path: AppRoutes.ruanganJadwal,
        builder: (context, state) => const JadwalRuanganPage(),
      ),
      GoRoute(
        path: AppRoutes.ruanganBooking,
        builder: (context, state) => const BookingRuanganPage(),
      ),
      GoRoute(
        path: AppRoutes.dkm,
        builder: (context, state) => DkmPage(),
      ),
      GoRoute(
        path: AppRoutes.muazin,
        builder: (context, state) => MuazinPage(),
      ),
      GoRoute(
        path: AppRoutes.kajianLive,
        builder: (context, state) => KajianListPage(
          title: 'Riwayat Kajian Live',
          tag: 'Kajian Live',
          badgeColor: const Color(0xFFE53935),
          provider: kajianLiveListProvider,
        ),
      ),
      GoRoute(
        path: AppRoutes.kajianTafsir,
        builder: (context, state) => KajianListPage(
          title: 'Kajian Tafsir Quran',
          tag: 'Tafsir Qur’an',
          badgeColor: const Color(0xFF048C7C),
          provider: kajianTafsirListProvider,
        ),
      ),
      GoRoute(
        path: AppRoutes.kajianDetail,
        builder: (context, state) => const KajianDetailPage(),
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
        path: AppRoutes.notifikasiInvoice,
        builder: (context, state) => const InvoiceNotifikasiPage(),
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
        path: AppRoutes.kalenderDzulhijjah,
        builder: (context, state) => KalenderdzulhijjahPage(),
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
