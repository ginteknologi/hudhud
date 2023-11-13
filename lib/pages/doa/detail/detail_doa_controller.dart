import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/doa/doa_service.dart';
import 'package:mesjid_app/routes/doa/index.dart';

class DetailDoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

  List listDoa = [].obs;

  var txtController = TextEditingController();

  getData() async {
    final result = await DoaService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListDoa() async {
    return listDoa = [
      {
        "id": 1,
        "title": "Doa Bangun Tidur",
        "subtitle": 'Segala puji bagi Allah, Tuhan yang menghidupkan kami setelah ia mematikan kami. Kepada-Nyalah kebangkitan hari kiamat',
        // "kutipan": 'QS. Al-Baqoroh 185',
        "kutipan": '',
        "viewer": "10"
      },
      // {
      //   "id": 2,
      //   "title": "Sholat Duha",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 3,
      //   "title": "Sholat Rawatib",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 4,
      //   "title": "Sholat Tahajud",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 5,
      //   "title": "Sholat Hajat",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 1,
      //   "title": "Sholat Terawih",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 2,
      //   "title": "Sholat Duha",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 3,
      //   "title": "Sholat Rawatib",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 4,
      //   "title": "Sholat Tahajud",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 5,
      //   "title": "Sholat Hajat",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 1,
      //   "title": "Sholat Terawih",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 2,
      //   "title": "Sholat Duha",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 3,
      //   "title": "Sholat Rawatib",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 4,
      //   "title": "Sholat Tahajud",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 5,
      //   "title": "Sholat Hajat",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 1,
      //   "title": "Sholat Terawih",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 2,
      //   "title": "Sholat Duha",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 3,
      //   "title": "Sholat Rawatib",
      //   "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 4,
      //   "title": "Sholat Tahajud",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
      // {
      //   "id": 5,
      //   "title": "Sholat Hajat",
      //   "subtitle":
      //       '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
      //   "kutipan": 'QS. Al-Baqoroh 185',
      //   "viewer": "10"
      // },
    ];
  }

  goToDetail(param) {
    Get.toNamed('${RoutesDoa.root}/${param['id']}/content',
        arguments: {"selectedDoa": param});
  }

  @override
  void onInit() {
    getListDoa();
    super.onInit();
  }
}
