import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';
import 'package:mesjid_app/routes/quran/index.dart';

class ListAyatQuranController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listSurah = [].obs;

  var txtController = TextEditingController();

  getData() async {
    final result = await QuranService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  goToDetail(param) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesQuran.root}/detail/${param['id']}',
        arguments: {"selectedSurah": param});
  }

  getAyats() async {
    return listSurah = [
      {
        "id": 2,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 3,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 4,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 5,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 6,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 7,
        "title": "Al-Ikhlas",
        "subTitle":
            "Pembukaan terus menerus yaaa Pembukaan terus menerus yaaa ",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "75"
      },
      {
        "id": 8,
        "title": "Al-Ikhlas",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "75"
      },
      {
        "id": 9,
        "title": "Al-Ikhlas",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "105"
      },
      {
        "id": 10,
        "title": "Al-Anfal",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "105"
      },
      {
        "id": 11,
        "title": "Al-Anfal",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "105"
      },
    ];
  }

  @override
  void onInit() {
    getAyats();
    super.onInit();
  }
}
