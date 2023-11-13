import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/button/iconbutton.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';

class DashboardController extends GetxController {
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

  RxBool showPopupInfaq = true.obs;
  DialogPopupInfaq dialogPopupInfaq = DialogPopupInfaq.subuh;

  getData() async {
    // final result = await DashboardService().getList();
    // dataTerbaru.value = result['data'];
    // print(dataTerbaru);
    lastRead.value = dataStore.read('perAyatLastRead');
    dataTerbaru.value = {
      "success": true,
      "message": "Success",
      "data": {
        "artikel": {
          "id": 1,
          "image": "https://storage.nu.or.id/storage/post/16_9/big/gambar-whatsapp-2023-08-21-pukul-175147_1692615363.webp",
          "judul": "Sedekah yang Paling Utama adalah yang Paling Sesuai dengan Kondisi Penerima Sedekah",
          "isi": "Disalurkan untuk biaya operasional dan pemeliharaan Masjid An-Ni’ma",
          "tanggal": "2023-10-31T12:59:58.000Z",
          "url": 'artikel/1',
          "createdAt": "2023-10-31T13:00:02.000Z",
          "updatedAt": "2023-10-31T13:00:03.000Z"
        },
        "doa": {
          "id": 1,
          // "image": "https://storage.nu.or.id/storage/post/16_9/big/gambar-whatsapp-2023-08-21-pukul-175147_1692615363.webp",
          "image": "https://harakahdaily.net/wp-content/uploads/2020/03/Doa-Mohon-Perlindungan-Dari-Ilmu-Tak-Bermanfaat-IslamRamah.co_.jpeg",
          "judul": "Doa Bangun Tidur",
          "isi": "Ini isinya",
          "tanggal": "2023-10-31T12:59:58.000Z",
          "url": 'doa/1',
          "createdAt": "2023-10-31T13:00:02.000Z",
          "updatedAt": "2023-10-31T13:00:03.000Z"
        },
        "campaign": {
          "id": 1,
          // "image": "https://storage.nu.or.id/storage/post/16_9/big/gambar-whatsapp-2023-08-21-pukul-175147_1692615363.webp",
          "image": "https://masjidannimah.id/wp-content/uploads/2023/10/image-36.png",
          "judul": "Sedekah Mesjid",
          "isi": "Disalurkan untuk biaya operasional dan pemeliharaan Masjid An-Ni’ma",
          "tanggal": "2023-10-31T12:59:58.000Z",
          "url": "sedekah/1",
          "createdAt": "2023-10-31T13:00:02.000Z",
          "updatedAt": "2023-10-31T13:00:03.000Z"
        }
      }
    };
    var newdata = constructDataTerbaru(dataTerbaru.value);
    // constructLatestData(dataTerbaru.value);
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

    var tmptime = ("05.10").split('.');
    var setTimeTo = new DateTime(timeleft.year, timeleft.month,
        timeleft.day + 1, int.parse(tmptime[0]), int.parse(tmptime[1]));

    var thistime = getNextLargerNumber(hourminutes, listWaktu);
    if (thistime == -1) {
      listWaktu[0]['active'] = true;
      var time = listWaktu[0]['waktu'].split('.');
      var setTimeTo = new DateTime(timeleft.year, timeleft.month,
          timeleft.day + 1, int.parse(time[0]), int.parse(time[1]));
      duration.value = timesBetween(timeleft, setTimeTo);
    } else {
      for (var el in listWaktu) {
        el['active'] = false;
        if (thistime['id'] == el['id']) {
          el['active'] = true;
          var time = el['waktu'].split('.');
          var setTimeTo = new DateTime(timeleft.year, timeleft.month,
              timeleft.day, int.parse(time[0]), int.parse(time[1]));
          duration.value = timesBetween(timeleft, setTimeTo);
          // var setTime = new DateTime(
          //     timeleft.year, timeleft.month, timeleft.day, time[0], time[1]);
        }
      }
    }
    // ======
    if (timeleft.hour > 6 && timeleft.hour < 23) {
      dialogPopupInfaq = DialogPopupInfaq.pagi;
      showPopupInfaq.value = true;
    } else if (timeleft.hour > 2 && timeleft.hour < 6) {
      dialogPopupInfaq = DialogPopupInfaq.subuh;
      showPopupInfaq.value = true;
    } else {
      showPopupInfaq.value = false;
    }
    // showPopupInfaq.value = true;
  }

  startWaktu() {
    Timer.periodic(new Duration(seconds: 1), (timer) {
      txttime.value = getTimeRemaining(duration.value);
      if (duration.value == 0) {
        getWaktu();
      }
      duration.value--;
    });
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

  int timesBetween(DateTime from, DateTime to) {
    // from = DateTime(from.year, from.month, from.day, from.hour, fr);
    // to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inSeconds);
  }

  getTimeRemaining(waktu) {
    var detik = waktu;
    var h = (detik / 3600).floor();
    var m = ((detik % 3600) / 60).floor();
    // var s = ((detik % 3600) % 60).floor();

    // var hDisplay = h > 0 ? '${h}${h == 1 ? " jam " : " jam "}' : "";
    // var mDisplay = m > 0 ? '${m}${m == 1 ? " menit " : " menit "}' : "";
    // var sDisplay = s > 0 ? '${s}${s == 1 ? " detik" : " detik"}' : "";
    var hDisplay = h > 0 ? '${h} jam ' : '';
    var mDisplay = m > 0 ? '${m} menit' : '';
    return hDisplay + mDisplay;
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
      // {"label": "Al-Quran", "icon": "assets/icons/alquran.svg", "urlNav": ""},
      // {"label": "Ruangan", "icon": "assets/icons/ruangan.svg", "urlNav": ""},
      {
        "label": "Artikel/Informasi",
        "icon": "assets/icons/artikel.svg",
        "urlNav": "/artikel"
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
        "image": "https://img.youtube.com/vi/uMFFFymo21w/0.jpg",
        "url": "https://www.youtube.com/watch?v=uMFFFymo21w",
        "id": 1
      },
      {
        "title": "30 Hari Setelah BADAI AL-AQSA | Kajian Subuh",
        "subtitle": "Ust. Ihsan Tanjung, Lc, MA ",
        "flag": "LIVE",
        "image": "https://img.youtube.com/vi/AkEPZYUGZvE/0.jpg",
        "url": "https://www.youtube.com/watch?v=AkEPZYUGZvE",
        "id": 2
      },
      {
        "title": "Shalat adalah Penolongmu | Kajian Maghrib",
        "subtitle": "Ust. DR. Iqbal Subhan Nugraha, Lc, MA",
        "flag": "LIVE",
        "image": "https://img.youtube.com/vi/a2YodUWUhTE/0.jpg",
        "url": "https://www.youtube.com/watch?v=a2YodUWUhTE",
        "id": 3
      },
      {
        "title": "Info Palestina | Kajian Subuh",
        "subtitle": "Ust. DR. Arifin Nugroho, Lc, MA",
        "flag": "LIVE",
        "image": "https://img.youtube.com/vi/U-Hg6wQD5CA/0.jpg",
        "url": "https://www.youtube.com/watch?v=U-Hg6wQD5CA",
        "id": 4
      },
      {
        "title": "Memberi Menerangkan Hati | Kajian Umum",
        "subtitle": "Ust. Derry Sulaiman",
        "flag": "LIVE",
        "image": "https://img.youtube.com/vi/ivay-bfTUDg/0.jpg",
        "url": "https://www.youtube.com/watch?v=ivay-bfTUDg",
        "id": 5
      }
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
          url: el['url'],
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

  void _showPopup() {
    Get.defaultDialog(
      backgroundColor: Colors.transparent,
      barrierDismissible: true,
      contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
      title: '',
      titleStyle: TextStyle(height: 0),
      titlePadding: EdgeInsets.all(0),
      content: Container(
        constraints: BoxConstraints.loose(Size.infinite),
        height: 400,
        width: Get.width - 42,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: dialogPopupInfaq == DialogPopupInfaq.pagi
                  ? AssetImage('assets/img/infaq_pagi.png')
                  : AssetImage('assets/img/infaq_subuh.png'),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter),
        ),
      ),
      confirm: ButtonElevated(
        title: 'Bismillah Infaq',
        width: 165,
        bgcolor: dialogPopupInfaq == DialogPopupInfaq.pagi
            ? Color(0xFFD9A04A)
            : Get.theme.primaryColor,
        height: 45,
        color: Colors.white,
        radius: 7,
        shadow: false,
        onPressed: () {
          // Navigator.pop(context);
          // Get.back();
          // print(showPopupInfaq.value);
          // showPopupInfaq.value = false;
          Get.toNamed('${RoutesSedekah.root}/1');
        },
      ),
      // confirm: ButtonElevated(
      //   title: 'Siap, Bismillah Infaq',
      //   width: 165,
      //   bgcolor: dialogPopupInfaq == DialogPopupInfaq.pagi
      //       ? Color(0xFFD9A04A)
      //       : Get.theme.primaryColor,
      //   height: 45,
      //   color: Colors.white,
      //   radius: 7,
      //   shadow: false,
      //   onPressed: () {
      //     // Navigator.pop(context);
      //     Get.back();
      //   },
      // ),
    );
  }

  @override
  void onInit() async {
    getData();
    getList();
    getMenuHome();
    getKajianLive();
    // getListArtikel();
    startWaktu();
    getAllMenu();
    getWaktu();
    getListKota();

    if (showPopupInfaq.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPopup();
        showPopupInfaq.value = false;
      });
    }

    super.onInit();
  }
}

enum DialogPopupInfaq { subuh, pagi }

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
        'url': url,
      };
}
