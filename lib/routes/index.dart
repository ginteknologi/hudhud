import 'package:masjid_app/routes/auth/index.dart';
import 'package:masjid_app/routes/akun/index.dart';
import 'package:masjid_app/routes/artikel/index.dart';
import 'package:masjid_app/routes/doa/index.dart';
import 'package:masjid_app/routes/dzikir/index.dart';
import 'package:masjid_app/routes/hadits/index.dart';
// import 'package:masjid_app/routes/dkm/index.dart';
import 'package:masjid_app/routes/home/index.dart';
import 'package:masjid_app/routes/notifikasi/index.dart';
import 'package:masjid_app/routes/onboard/index.dart';
import 'package:masjid_app/routes/quran/index.dart';
import 'package:masjid_app/routes/ruangan/index.dart';
import 'package:masjid_app/routes/sedekah/index.dart';
import 'package:masjid_app/routes/kiblat/index.dart';
import 'package:masjid_app/routes/test/index.dart';

class AppPages {
  static var list = [
    ...PagesAuth.pages,
    ...PagesAkun.pages,
    ...PagesArtikel.pages,
    ...PagesDoa.pages,
    // ...PagesDkm.pages,
    ...PagesHome.pages,
    ...PagesQuran.pages,
    ...PagesRuangan.pages,
    ...PagesSedekah.pages,
    ...PagesOnboard.pages,
    ...PagesNotifikasi.pages,
    ...PagesKiblat.pages,
    ...PagesTest.pages,
    ...PagesHadits.pages,
    ...PagesDzikir.pages
  ];
  static var root = RoutesHome.splashscreen;
}
