import 'package:mesjid_app/routes/auth/index.dart';
import 'package:mesjid_app/routes/akun/index.dart';
import 'package:mesjid_app/routes/artikel/index.dart';
import 'package:mesjid_app/routes/doa/index.dart';
import 'package:mesjid_app/routes/dkm/index.dart';
import 'package:mesjid_app/routes/home/index.dart';
import 'package:mesjid_app/routes/notifikasi/index.dart';
import 'package:mesjid_app/routes/onboard/index.dart';
import 'package:mesjid_app/routes/quran/index.dart';
import 'package:mesjid_app/routes/ruangan/index.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';

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
    ...PagesNotifikasi.pages
  ];
  static var root = RoutesHome.splashscreen;
}
