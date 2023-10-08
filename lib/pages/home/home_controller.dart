import 'package:get/get.dart';
// import 'package:mesjid_app/pages/home/home_service.dart';

class HomeController extends GetxController {
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
      {"label": "Subuh", "waktu": "05.15"},
      {"label": "Dzuhur", "waktu": "12.30"},
      {"label": "Ashar", "waktu": "15.40"},
      {"label": "Maghrib", "waktu": "18.34"},
      {"label": "Isya", "waktu": "19.32"}
    ];
  }

  getMenuHome() async {
    return listMenuHome = [
      {"label": "Sedekah", "icon": "assets/icons/sedekah.svg", "urlNav": ""},
      {"label": "Kiblat", "icon": "assets/icons/kiblat.svg", "urlNav": ""},
      {"label": "Do'a", "icon": "assets/icons/doa.svg", "urlNav": ""},
      {"label": "Lainnya", "icon": "assets/icons/lainnya.svg", "urlNav": ""},
    ];
  }

  getAllMenu() async {
    return listAllMenu = [
      {"label": "Sedekah", "icon": "assets/icons/sedekah.svg", "urlNav": ""},
      {"label": "Kiblat", "icon": "assets/icons/kiblat.svg", "urlNav": ""},
      {"label": "Do'a/Hadist", "icon": "assets/icons/doa.svg", "urlNav": ""},
      {"label": "Al-Quran", "icon": "assets/icons/alquran.svg", "urlNav": ""},
      {"label": "Ruangan", "icon": "assets/icons/ruangan.svg", "urlNav": ""},
      {
        "label": "Artikel/Informasi",
        "icon": "assets/icons/artikel.svg",
        "urlNav": ""
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
    super.onInit();
  }
}
