import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_service.dart';

class BookingRuanganController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listJadwal = [].obs;
  var txtController = TextEditingController();
  var inputTanggal = "".obs;

  Rx<DateTime> selectedDay = DateTime.now().obs;
  RxString inputBulan = "".obs;

  var formInput = [].obs;

  getData() async {
    final result = await RuanganService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getForm() async {
    return formInput.value = [
      {
        "type": "datepicker",
        "label": "Tanggal",
        "placeholder": "Tanggal",
        "controller": inputTanggal,
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "text",
        "label": "Jam",
        "controller": txtController,
        "placeholder": "Jam",
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "text",
        "label": "Jenis Kegiatan",
        "placeholder": "Jenis Kegiatan",
        "controller": txtController,
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "text",
        "label": "Permintaan Khusus",
        "placeholder": "Permintaan Khusus",
        "controller": txtController,
        "maxline": 5,
        "multiText": true
      },
      {
        "type": "text",
        "label": "Nama Pemesan Ruangan",
        "placeholder": "Nama Pemesan Ruangan",
        "controller": txtController,
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "text",
        "label": "Kontak Pemesan",
        "placeholder": "Kontak Pemesan",
        "controller": txtController,
        "maxline": 1,
        "multiText": false
      },
    ];
  }

  @override
  void onInit() {
    super.onInit();
    getForm();
  }
}
