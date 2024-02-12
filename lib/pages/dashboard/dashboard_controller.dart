import 'package:get/get.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/pages/dashboard/dashboard_service.dart';

class DashboardController extends GetxController {
  final ctrlmain = Get.find<MainController>();

  final dataStore = GetStorage();
  var isLoadingKajianLive = true.obs;
  var isLoadingKajian = true.obs;
  var isLoadingArtikel = true.obs;
  var isLoadingLokasi = true.obs;
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
  var listArtikel = <ArtikelData>[
    ArtikelData(
        id: 1,
        judul: "dummy",
        tanggal: "1992-10-10",
        image: "https://dummyimage.com/600x400/000/fff"),
  ].obs;
  var listAllMenu = [].obs;
  var listKota = [].obs;
  var latestArtikel = {}.obs;
  var latestDoa = {}.obs;
  var latestCampaign = {}.obs;
  var duration = 0.obs;
  var txttime = "".obs;

  // GetDataKajian() async {
  // final result = await DashboardService().getList();
  // dataTerbaru.value = result['data'];
  // lastRead.value = dataStore.read('perAyatLastRead');
  // await Future.delayed(const Duration(seconds: 100), () {});
  // }

  GetDataArtikel() async {
    final artikelbaru = await DashboardService().getListArtikelBaru();
    listArtikel.value = [];
    for (var element in artikelbaru['data']) {
      listArtikel.add(ArtikelData(
          id: element['id'],
          judul: element['judul'],
          tanggal: element['tanggal'],
          image: element['image']));
    }
    isLoadingArtikel.value = false;
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
        "label": "Lainnya",
        "icon": "assets/icons/lainnya.svg",
        "urlNav": "lainnya"
      },
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
  }

  Future getKajianLive() async {
    final listresult = await DashboardService().getListKajian();
    listKajian.value = listresult['data'];
    isLoadingKajian.value = false;
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

  @override
  void onInit() async {
    getSliderKajianLive();
    GetDataArtikel();
    getMenuHome();
    getAllMenu();
    getListKota();
    setFcm();
    super.onInit();
  }
}

enum DialogPopupInfaq { subuh, pagi }
