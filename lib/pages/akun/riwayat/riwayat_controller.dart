import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';
import 'package:mesjid_app/routes/quran/index.dart';

class RiwayatController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listRiwayat = [].obs;

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

  getRiwayats() async {
    return listRiwayat = [
      {
        "id": 2,
        "title": 100000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 3,
        "title": 100000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Makiah",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 4,
        "title": 120000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 5,
        "title": 1000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 6,
        "title": 1200000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 7,
        "title": 3000000,
        "subTitle":
            "Pembukaan terus menerus yaaa Pembukaan terus menerus yaaa ",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 8,
        "title": 3000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 9,
        "title": 3000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 10,
        "title": 3000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
    ];
  }

  @override
  void onInit() {
    getRiwayats();
    super.onInit();
  }
}
