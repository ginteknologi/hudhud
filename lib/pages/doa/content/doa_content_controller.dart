import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';

class ContentDoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

  List listDoa = [].obs;

  var txtController = TextEditingController();

  getData() async {
    final result = await DoaService().getDetail();
    list.value = result;
    isLoadingList.value = false;
  }

  getListDoa() async {
    return listDoa = [
      {
        "id": 1,
        "title": "Sholat Terawih",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 2,
        "title": "Sholat Duha",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 3,
        "title": "Sholat Rawatib",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 4,
        "title": "Sholat Tahajud",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 5,
        "title": "Sholat Hajat",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 1,
        "title": "Sholat Terawih",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 2,
        "title": "Sholat Duha",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 3,
        "title": "Sholat Rawatib",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 4,
        "title": "Sholat Tahajud",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 5,
        "title": "Sholat Hajat",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 1,
        "title": "Sholat Terawih",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 2,
        "title": "Sholat Duha",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 3,
        "title": "Sholat Rawatib",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 4,
        "title": "Sholat Tahajud",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 5,
        "title": "Sholat Hajat",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 1,
        "title": "Sholat Terawih",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 2,
        "title": "Sholat Duha",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 3,
        "title": "Sholat Rawatib",
        "subtitle": '“Dan sesungguhnya Allah itu Maha Pemaaf”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 4,
        "title": "Sholat Tahajud",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
      {
        "id": 5,
        "title": "Sholat Hajat",
        "subtitle":
            '“Lorem ipsum dolor sit amet consectetur. Sem felis sagittis ut nunc duis nec. Pharetra tincidunt aliquam ultricies elementum blandit aliquet elit hendrerit.”',
        "kutipan": 'QS. Al-Baqoroh 185',
        "viewer": "10"
      },
    ];
  }

  goToDetail(param) {}

  @override
  void onInit() async {
    await getData();
    getListDoa();
    super.onInit();
  }
}
