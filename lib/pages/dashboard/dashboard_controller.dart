import 'dart:convert';

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
    // final result = await DashboardService().getList();
    // dataTerbaru.value = result['data'];
    // print(dataTerbaru);
    dataTerbaru.value = {
      "success": true,
      "message": "Success",
      "data": {
        "artikel": {
          "id": 1,
          "image": "https://dummyimage.com/600x400/000/fff",
          "judul": "Ini Judul",
          "isi": "Ini isinya",
          "tanggal": "2023-10-31T12:59:58.000Z",
          "idCategoryArtikel": 1,
          "createdAt": "2023-10-31T13:00:02.000Z",
          "updatedAt": "2023-10-31T13:00:03.000Z"
        },
        "doa": {
          "id": 1,
          "judul": "asdasdas",
          "seo": "asdasdas",
          "isi": "sdasdasdas",
          "surat": "sdasdasdasd",
          "idCategoryDoa": 1,
          "createdAt": "2023-10-24T15:07:09.000Z",
          "updatedAt": "2023-10-24T15:07:10.000Z"
        },
        "campaign": {
          "id": 1,
          "image": "https://dummyimage.com/600x400/000/fff",
          "judul": "Sedekah Mudharabah",
          "seo": "sedekah-mudharabah",
          "isi": "asdasdassa",
          "deadline": "2024-01-01T03:12:11.000Z",
          "dana_kebutuhan": 14000000,
          "total_online": 0,
          "total_offline": 0,
          "total": 0,
          "createdAt": "2023-10-31T03:11:51.000Z",
          "updatedAt": "2023-10-31T03:11:52.000Z"
        }
      }
    };
    var newdata = constructDataTerbaru(dataTerbaru.value);
    // print(jsonEncode(newdata));
    listArtikel = newdata;
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

  // getListArtikel() async {
  //   return listArtikel = [
  //     {
  //       "title": "Memurnikan Akikah Menebarkan Sunnah",
  //       "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
  //       "kategori": "Artikel",
  //       "image": "assets/icons/image-item1.png",
  //       "time": "17:40",
  //       "date": "17 Agustus 2023",
  //       "url": ""
  //     },
  //     {
  //       "title":
  //           "Do’a Sebelum Masuk Mesjid اللَّهُمَّ افْتَحْ لِيْ أَبْوَابَ رَحْمَتِكَ",
  //       "subtitle": "Ust. Abdullah Sholeh Hadrami",
  //       "kategori": "Artikel",
  //       "image": "assets/icons/image-item1.png",
  //       "time": "17:40",
  //       "date": "17 Agustus 2023",
  //       "url": ""
  //     },
  //     {
  //       "title": "Penyaluran Sedekah Untuk Biaya Pengobatan",
  //       "subtitle": "Ust. M. Budi Zulkarnaen Hasibuan, Lc, MH",
  //       "kategori": "Artikel",
  //       "image": "assets/icons/image-item1.png",
  //       "time": "17:40",
  //       "date": "17 Agustus 2023",
  //       "url": ""
  //     },
  //     {
  //       "title": '"Sampaikanlah dariku walau hanya satu ayat." (HR. Bukhari)',
  //       "subtitle": "Ust. Abdullah Sholeh Hadrami",
  //       "kategori": "Artikel",
  //       "image": "assets/icons/image-item1.png",
  //       "time": "17:40",
  //       "date": "17 Agustus 2023",
  //       "url": ""
  //     },
  //   ];
  // }

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
      var item = data['data'];
      var keys = item.keys;
      for (var key in keys) {
        var el = item[key];
        var tgl = "";
        var timeleft;
        if (el['tanggal'] != null) {
          timeleft = DateTime.parse(el['tanggal']);
          tgl = Moment.parse("$timeleft")
              .format("dd MMMM yyyy", localeOverride: 'id');
        }

        items.add(LatestNews(
          id: el['id'],
          date: tgl,
          time: tgl != "" ? "${timeleft.hour} : ${timeleft.minute}" : '',
          title: el['judul'],
          subtitle: el['isi'],
          image: el['image'] ?? 'https://dummyimage.com/600x400/000/fff',
          kategori: key,
          url: "1",
        ));
      }
      return items;
    }
    // for (var element in collection) {

    // }
  }

  @override
  void onInit() async {
    getData();
    getList();
    getMenuHome();
    getKajianLive();
    // getListArtikel();
    getAllMenu();
    getWaktu();
    getListKota();
    super.onInit();
  }
}

class LatestNews {
  int id;
  String title, subtitle, kategori, image, time, date, url;
  LatestNews(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.kategori,
      required this.image,
      required this.time,
      required this.date,
      required this.url});

  Map toJson() => {
        'title': title,
        'subtitle': subtitle,
        'kategori': kategori,
        'image': image,
        'time': time,
      };
}
