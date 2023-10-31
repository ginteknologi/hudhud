import 'package:get/get.dart';
import 'package:mesjid_app/pages/dashboard/dashboard_service.dart';
import 'package:simple_moment/simple_moment.dart';

class DashboardController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  var todayDate = "".obs;
  var dataTerbaru = {}.obs;
  List listWaktu = [].obs;
  List listMenuHome = [].obs;
  List listKajianLive = [].obs;
  List listArtikel = [].obs;
  List listAllMenu = [].obs;
  List listKota = [].obs;

  getData() async {
    final result = await DashboardService().getList();
    dataTerbaru.value = result['data'];
    print(dataTerbaru);
    isLoadingList.value = false;
  }

  getList() async {
    return listWaktu = [
      {
        "label": "Subuh",
        "waktu": "05.15",
        "active": false,
        "id": 1,
        "cardImage": "assets/img/card/card_subuh.png"
      },
      {
        "label": "Dzuhur",
        "waktu": "12.30",
        "active": false,
        "id": 2,
        "cardImage": "assets/img/card/card_dzuhur.png"
      },
      {
        "label": "Ashar",
        "waktu": "15.40",
        "active": false,
        "id": 3,
        "cardImage": "assets/img/card/card_ashar.png"
      },
      {
        "label": "Maghrib",
        "waktu": "18.34",
        "active": false,
        "id": 4,
        "cardImage": "assets/img/card/card_maghrib.png"
      },
      {
        "label": "Isya",
        "waktu": "19.32",
        "active": false,
        "id": 5,
        "cardImage": "assets/img/card/card_isya.png"
      }
    ];
  }

  getWaktu() async {
    var timeleft = DateTime.now();
    todayDate.value =
        Moment.parse("$timeleft").format("EEEE, dd MMMM", localeOverride: 'id');
    var hourAndMinutes = "${timeleft.hour}.${timeleft.minute}";
    int hourminutes = int.parse("${timeleft.hour}${timeleft.minute}");

    var thistime = getNextLargerNumber(hourminutes, listWaktu);
    if (thistime == -1) {
      listWaktu[0]['active'] = true;
    } else {
      for (var el in listWaktu) {
        el['active'] = false;
        if (thistime['id'] == el['id']) {
          el['active'] = true;
        }
      }
    }
  }

  getNextLargerNumber(int number, List array) {
    for (var i = 0; i < array.length; i++) {
      var numberTime = int.parse(array[i]['waktu'].split('.').join());
      if (number < numberTime) {
        return array[i];
      }
    }
    return -1;
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
        "url": "",
        "id": 1
      },
      {
        "title": "Indahnya Husnul Khotimah",
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": "",
        "id": 1
      },
      {
        "title": "Asbabun Nuzul",
        "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": "",
        "id": 1
      },
      {
        "title": "Indahnya Husnul Khotimah",
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": "",
        "id": 1
      },
      {
        "title": "Asbabun Nuzul",
        "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": "",
        "id": 1
      },
      {
        "title": "Indahnya Husnul Khotimah",
        "subtitle": "Ust. Abdullah Sholeh Hadrami",
        "flag": "LIVE",
        "image": "assets/icons/image-item1.png",
        "url": "",
        "id": 1
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

  @override
  void onInit() async {
    getData();
    getList();
    getMenuHome();
    getKajianLive();
    getListArtikel();
    getAllMenu();
    getWaktu();
    getListKota();
    super.onInit();
  }
}
