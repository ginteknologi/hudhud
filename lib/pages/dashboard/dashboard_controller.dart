import 'dart:async';

import 'package:get/get.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/models/kontenSosmed.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/pages/dashboard/dashboard_service.dart';

class DashboardController extends GetxController {
  final ctrlmain = Get.find<MainController>();
  // countDown
  Rx<DateTime> _targetDate = DateTime(2024, 3, 10).obs;
  RxList<Map<String, dynamic>> countdownData = <Map<String, dynamic>>[].obs;
  late Timer _timer;
  //end countDown
  final dataStore = GetStorage();
  var isLoadingKajianLive = true.obs;
  var isLoadingKajian = true.obs;
  var isLoadingArtikel = true.obs;
  var isLoadingLokasi = false.obs;
  var isLoadingKontenSosmed = true.obs;
  // var isLoadingList = true.obs;
  var list = {}.obs;
  var lastRead = {}.obs;
  var todayDate = "".obs;
  var dataTerbaru = {}.obs;
  var listWaktu = [].obs;
  var listMenuHome = [].obs;
  var listKajianSlider = <KajianData>[
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
  ].obs;
  var listKajian = [].obs;
  var listKontenSosmed = [].obs;
  var listArtikel = <ArtikelData>[
    ArtikelData(
        id: 1,
        judul: "dummy",
        updatedAt: "1992-10-10",
        image: "https://dummyimage.com/600x400/000/fff"),
  ].obs;
  var listAllMenu = [].obs;
  var listKota = [].obs;
  var latestArtikel = {}.obs;
  var latestDoa = {}.obs;
  var latestCampaign = {}.obs;
  var duration = 0.obs;
  var txttime = "".obs;

  GetDataArtikel() async {
    try {
      final artikelbaru = await DashboardService().getListArtikelBaru();
      listArtikel.value = [];
      for (var element in artikelbaru['data']) {
        listArtikel.add(ArtikelData(
            id: element['id'],
            judul: element['judul'],
            updatedAt: element['updatedAt'],
            image: element['image']));
      }
      isLoadingArtikel.value = false;
    } catch (e) {
      print(e);
    }
  }

  getMenuHome() async {
    return listMenuHome.value = [
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
        "label": "Informasi",
        "icon": "assets/icons/informasi.svg",
        "urlNav": "/artikel"
      },
      {
        "label": "Hadits",
        "icon": "assets/icons/hadits.svg",
        "urlNav": "/hadits"
      },
      {
        "label": "Dzikir Pagi Petang",
        "icon": "assets/icons/dzikir_pagi_petang.svg",
        "urlNav": "/dzikir"
      },
      // {
      //   "label": "Lainnya",
      //   "icon": "assets/icons/lainnya.svg",
      //   "urlNav": "lainnya"
      // },
    ];
  }

  getAllMenu() async {
    return listAllMenu.value = [
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

  getSliderKajianLive() async {
    try {
      final result = await DashboardService().getSliderKajian();
      listKajianSlider.value = [];
      for (var element in result['data']) {
        listKajianSlider.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'],
            image: element['image'],
            link: element['link']));
      }
      isLoadingKajianLive.value = false;
    } catch (e) {
      print(e);
    }
  }

  getSliderKontenSosmed() async {
    try {
      final result = await DashboardService().getSliderKajiLive();
      listKontenSosmed.value = [];
      for (var i = 0; i < result['data'].length; i++) {
        var element = result['data'][i];
        listKontenSosmed.add(SosmedData(
            id: element['id'], image: element['image'], link: element['link']));
      }
      isLoadingKontenSosmed.value = false;
    } catch (e) {
      print(e);
    }
  }

  Future getKajianLive() async {
    try {
      final listresult = await DashboardService().getListKajiLive();
      listKajian.value = listresult['data'];
      isLoadingKajian.value = false;
    } catch (e) {
      print(e);
    }
  }

  Future getKajianTafsir() async {
    try {
      final listresult = await DashboardService().getListKajian();
      listKajian.value = listresult['data'];
      isLoadingKajian.value = false;
    } catch (e) {
      print(e);
    }
  }

  getListKota() {
    return listKota.value = [
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

  constructLatestData(data) {
    var item = data['data'];
    latestArtikel = item['artikel'];
    latestCampaign = item['campaign'];
    latestDoa = item['doa'];
  }

  setFcm() async {
    try {
      final isLogin = dataStore.read('isLogin');
      if (isLogin.toString() == 'true') {
        final fcm = dataStore.read('fcmtoken');
        var res = await HomeService().setToken(fcm);
        print('done fcm saving');
      }
    } catch (e) {
      print("<<<<<<<<<<Error set fcm>>>>>>>>>>>>");
      print(e);
    }
  }

  void _updateTimer(Timer timer) {
    DateTime currentDate = DateTime.now();
    Duration remainingTime = _targetDate.value.difference(currentDate);
    countdownData.assignAll([
      {'value': remainingTime.inDays, 'label': 'Hari'},
      {'value': remainingTime.inHours % 24, 'label': 'Jam'},
      {'value': remainingTime.inMinutes % 60, 'label': 'Menit'},
      {'value': remainingTime.inSeconds % 60, 'label': 'Detik'},
    ]);
  }

  @override
  void onInit() async {
    super.onInit();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);

    getSliderKajianLive();
    GetDataArtikel();
    getMenuHome();
    getAllMenu();
    getListKota();
    getSliderKontenSosmed();
    setFcm();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}

enum DialogPopupInfaq { subuh, pagi }
