import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listWaktu = [].obs;
  List listMenuHome = [].obs;
  List listKajianLive = [].obs;
  List listArtikel = [].obs;
  List listAllMenu = [].obs;

  getData() async {
    // final result = await HomeService().getList(page: 0, limit: 10);
    //dummy
    list.value = {
      "success": true,
      "message": "Berhasil",
      "data": {
        "page": 1,
        "limit": 8,
        "total": 1,
        "data": [
          {
            "id": 1,
            "point": 1,
            "pic": 7,
            "user_id": 4,
            "tag": "Bug",
            "priority": "Urgent",
            "judul": "asdasdasd",
            "keterangan": null,
            "status": "pending",
            "createdAt": "2023-09-22T15:58:20.020Z",
            "updatedAt": "2023-09-22T15:58:14.000Z"
          }
        ]
      }
    };
    // list.value = result['data'];
    isLoadingList.value = false;
  }

  getList() async {
    return listWaktu = [
      {
        "label": "Subuh",
        "waktu": "05.15",
        "active": false,
        "cardImage": "assets/img/card/card_subuh.png"
      },
      {
        "label": "Dzuhur",
        "waktu": "12.30",
        "active": false,
        "cardImage": "assets/img/card/card_dzuhur.png"
      },
      {
        "label": "Ashar",
        "waktu": "15.40",
        "active": false,
        "cardImage": "assets/img/card/card_ashar.png"
      },
      {
        "label": "Maghrib",
        "waktu": "18.34",
        "active": false,
        "cardImage": "assets/img/card/card_maghrib.png"
      },
      {
        "label": "Isya",
        "waktu": "19.32",
        "active": false,
        "cardImage": "assets/img/card/card_isya.png"
      }
    ];
  }

  getWaktu() async {
    var timeleft = DateTime.now();
    var hourAndMinutes = "${timeleft.hour}.${timeleft.minute}";
    int hourminutes = int.parse("${timeleft.hour}${timeleft.minute}");
    for (var el in listWaktu) {
      var numberTime = int.parse(el['waktu'].split('.').join());
      if (hourAndMinutes == el['waktu']) {
        el['active'] = true;
        break;
      } else if (numberTime > hourminutes) {
        el['active'] = true;
        break;
      } else {
        el['active'] = true;
        break;
      }
    }

    print(timeleft.hour.toString() +
        ":" +
        timeleft.minute.toString() +
        ":" +
        timeleft.second.toString());
    print(listWaktu);
  }

  getMenuHome() async {
    return listMenuHome = [
      {
        "label": "Sedekah",
        "icon": "assets/icons/sedekah.svg",
        "urlNav": "/sedekah"
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
        "icon": "assets/icons/sedekah.svg",
        "urlNav": "/sedekah"
      },
      {
        "label": "Kiblat",
        "icon": "assets/icons/kiblat.svg",
        "urlNav": "/kiblat"
      },
      {"label": "Do'a", "icon": "assets/icons/doa.svg", "urlNav": "/doa"},
      {"label": "Al-Quran", "icon": "assets/icons/alquran.svg", "urlNav": ""},
      {"label": "Ruangan", "icon": "assets/icons/ruangan.svg", "urlNav": ""},
      {
        "label": "Artikel/Informasi",
        "icon": "assets/icons/artikel.svg",
        "urlNav": "/artikel"
      },
      {"label": "DKM", "icon": "assets/icons/dkm.svg", "urlNav": ""},
    ];
  }

  getKajianLive() async {
    return listKajianLive = [
      {
        "title": "Asbabun Nuzul",
        "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": ""
      },
      {
        "title": "Indahnya Husnul Khotimah",
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": ""
      },
      {
        "title": "Asbabun Nuzul",
        "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": ""
      },
      {
        "title": "Indahnya Husnul Khotimah",
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": ""
      },
      {
        "title": "Asbabun Nuzul",
        "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": ""
      },
      {
        "title": "Indahnya Husnul Khotimah",
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": ""
      },
    ];
  }

  getListArtikel() async {
    return listArtikel = [
      {
        "title": "Memurnikan Akikah Menebarkan Sunnah",
        "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
        "kategori": "Artikel",
        "image": "assets/icons/image-item1.png",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "url": ""
      },
      {
        "title":
            "Do’a Sebelum Masuk Mesjid اللَّهُمَّ افْتَحْ لِيْ أَبْوَابَ رَحْمَتِكَ",
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "kategori": "Artikel",
        "image": "assets/icons/image-item1.png",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "url": ""
      },
      {
        "title": "Penyaluran Sedekah Untuk Biaya Pengobatan",
        "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
        "kategori": "Artikel",
        "image": "assets/icons/image-item1.png",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "url": ""
      },
      {
        "title": '"Sampaikanlah dariku walau hanya satu ayat." (HR. Bukhari)',
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "kategori": "Artikel",
        "image": "assets/icons/image-item1.png",
        "time": "17:40",
        "date": "17 Agustus 2023",
        "url": ""
      },
    ];
  }

  @override
  void onInit() {
    getList();
    getMenuHome();
    getKajianLive();
    getListArtikel();
    getAllMenu();
    getWaktu();
    super.onInit();
  }
}
