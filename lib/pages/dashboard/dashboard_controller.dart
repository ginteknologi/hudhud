import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/pages/dashboard/dashboard_service.dart';

class DashboardController extends GetxController {
  final ctrlmain = Get.find<MainController>();

  final dataStore = GetStorage();
  var isLoadingList = true.obs;
  var list = {}.obs;
  var lastRead = {}.obs;
  var todayDate = "".obs;
  var dataTerbaru = {}.obs;
  List listWaktu = [].obs;
  List listMenuHome = [].obs;
  List listKajianLive = [].obs;
  List listArtikel = [].obs;
  List listAllMenu = [].obs;
  List listKota = [].obs;
  var latestArtikel = {}.obs;
  var latestDoa = {}.obs;
  var latestCampaign = {}.obs;
  var duration = 0.obs;
  var txttime = "".obs;

  // RxBool showPopupInfaq = true.obs;
  // DialogPopupInfaq dialogPopupInfaq = DialogPopupInfaq.subuh;

  getData() async {
    final result = await DashboardService().getList();
    dataTerbaru.value = result['data'];
    lastRead.value = dataStore.read('perAyatLastRead');
    var newdata = constructDataTerbaru(dataTerbaru);
    listArtikel = newdata;
    isLoadingList.value = false;
  }

  getMenuHome() async {
    return listMenuHome = [
      {
        "label": "Sedekah",
        "icon": "assets/icons/sedekah_blur.svg",
        "urlNav": ""
      },
      {
        "label": "Kiblat",
        "icon": "assets/icons/kiblat.svg",
        "urlNav": "/kiblat"
      },
      {"label": "Do'a", "icon": "assets/icons/doa.svg", "urlNav": "/doa"},
      {
        "label": "Lainnya",
        "icon": "assets/icons/lainnya.svg",
        "urlNav": "lainnya"
      },
    ];
  }

  getAllMenu() async {
    return listAllMenu = [
      {
        "label": "Sedekah",
        "icon": "assets/icons/sedekah_blur.svg",
        // "urlNav": "/sedekah"
        "urlNav": ""
      },
      {
        "label": "Kiblat",
        "icon": "assets/icons/kiblat.svg",
        "urlNav": "/kiblat"
      },
      {"label": "Do'a", "icon": "assets/icons/doa.svg", "urlNav": "/doa"},
      // {"label": "Al-Quran", "icon": "assets/icons/alquran.svg", "urlNav": ""},
      // {"label": "Ruangan", "icon": "assets/icons/ruangan.svg", "urlNav": ""},
      {
        "label": "Artikel/Informasi",
        "icon": "assets/icons/artikel.svg",
        "urlNav": "/artikel"
      },
      {
        "label": "Dzikir Pagi Petang",
        "icon": "assets/icons/dzikir_pagi_petang.svg",
        "urlNav": "/dzikir"
      },
      {
        "label": "Hadits",
        "icon": "assets/icons/hadits.svg",
        "urlNav": "/hadits"
      },
      // {"label": "DKM", "icon": "assets/icons/dkm.svg", "urlNav": "dkm"},
    ];
  }

  getKajianLive() async {
    return listKajianLive = [
      {
        "title": "PALESTINA BUKAN SEKEDAR ISU KEMANUSIAAN | MT Sakinah",
        "subtitle": "Ustadzh Umi Irena Handono & Ustadzh Sally",
        "flag": "LIVE",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "image": "https://img.youtube.com/vi/uMFFFymo21w/0.jpg",
        "url": "https://www.youtube.com/watch?v=uMFFFymo21w",
        "id": 1
      },
      {
        "title": "30 Hari Setelah BADAI AL-AQSA | Kajian Subuh",
        "subtitle": "Ust. Ihsan Tanjung, Lc, MA ",
        "flag": "LIVE",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "image": "https://img.youtube.com/vi/AkEPZYUGZvE/0.jpg",
        "url": "https://www.youtube.com/watch?v=AkEPZYUGZvE",
        "id": 2
      },
      {
        "title": "Shalat adalah Penolongmu | Kajian Maghrib",
        "subtitle": "Ust. DR. Iqbal Subhan Nugraha, Lc, MA",
        "flag": "LIVE",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "image": "https://img.youtube.com/vi/a2YodUWUhTE/0.jpg",
        "url": "https://www.youtube.com/watch?v=a2YodUWUhTE",
        "id": 3
      },
      {
        "title": "Info Palestina | Kajian Subuh",
        "subtitle": "Ust. DR. Arifin Nugroho, Lc, MA",
        "flag": "LIVE",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "image": "https://img.youtube.com/vi/U-Hg6wQD5CA/0.jpg",
        "url": "https://www.youtube.com/watch?v=U-Hg6wQD5CA",
        "id": 4
      },
      {
        "title": "Memberi Menerangkan Hati | Kajian Umum",
        "subtitle": "Ust. Derry Sulaiman",
        "flag": "LIVE",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "image": "https://img.youtube.com/vi/ivay-bfTUDg/0.jpg",
        "url": "https://www.youtube.com/watch?v=ivay-bfTUDg",
        "id": 5
      }
    ];
  }

  getListKota() {
    return listKota = [
      {
        "id": 1,
        "label": "Jakarta",
      },
      {
        "id": 1,
        "label": "Bandung",
      },
      {
        "id": 1,
        "label": "Aceh",
      },
      {
        "id": 1,
        "label": "Bogor",
      },
      {
        "id": 1,
        "label": "Medan",
      },
      {
        "id": 1,
        "label": "Palembang",
      },
      {
        "id": 1,
        "label": "Samarinda",
      },
      {
        "id": 1,
        "label": "Depok",
      },
    ];
  }

  constructDataTerbaru(data) {
    if (data != null) {
      List<LatestNews> items = [];
      var item = data;
      var keys = item.keys;
      for (var key in keys) {
        var el = item[key];
        var tgl = "";
        var timeleft;
        if (el['createdAt'] != null) {
          timeleft = DateTime.parse(el['createdAt']);
          tgl = Moment.parse("$timeleft")
              .format("dd MMMM yyyy", localeOverride: 'id');
        }
        if (key == 'artikel') {
          el['kategori'] = 'Artikel';
        } else if (key == 'campaign') {
          el['kategori'] = 'Campaign';
        } else {
          el['kategori'] = 'Doa';
        }
        items.add(LatestNews(
          id: el['id'],
          date: tgl,
          time: tgl != "" ? "${timeleft.hour} : ${timeleft.minute}" : '',
          title: el['judul'],
          subtitle: el['isi'],
          image: el['image'] ?? 'https://dummyimage.com/600x400/000/fff',
          kategori: el['kategori'],
        ));
      }
      return items;
    }
  }

  constructLatestData(data) {
    var item = data['data'];
    latestArtikel = item['artikel'];
    latestCampaign = item['campaign'];
    latestDoa = item['doa'];
  }

  setFcm() async {
    final isLogin = dataStore.read('isLogin');
    if (isLogin.toString() == 'true') {
      final fcm = dataStore.read('fcmtoken');
      await HomeService().setToken(fcm);
      print('done fcm saving');
    }
  }

  @override
  void onInit() async {
    getData();
    getMenuHome();
    getKajianLive();
    getAllMenu();
    getListKota();
    setFcm();
    // if (ctrlmain.showPopupInfaq.isTrue) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     ctrlmain.showPopup();
    //     ctrlmain.showPopupInfaq.value = false;
    //   });
    // }

    super.onInit();
  }
}

enum DialogPopupInfaq { subuh, pagi }

class LatestNews {
  int id;
  String title, subtitle, kategori, image, time, date;
  LatestNews(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.kategori,
      required this.image,
      required this.time,
      required this.date});

  Map toJson() => {
        'title': title,
        'subtitle': subtitle,
        'kategori': kategori,
        'image': image,
        'time': time,
      };
}
