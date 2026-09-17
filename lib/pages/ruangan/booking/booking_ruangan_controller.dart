import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/ruangan/ruangan_service.dart';

class BookingRuanganController extends GetxController {
  var isLoadingList = false.obs;
  var list = {}.obs;
  List listJadwal = [].obs;
  var namaKegiatan = TextEditingController();
  var permintaan = TextEditingController();
  var nama = TextEditingController();
  var kontak = TextEditingController();
  var inputTanggal = "".obs;
  var jamMulai = "".obs;
  var jamSelesai = "".obs;

  Rx<DateTime> selectedDay = DateTime.now().obs;
  RxString inputBulan = "".obs;

  var formInput = [].obs;

  Future<List<dynamic>> getForm() async {
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
        "type": "timepicker",
        "label": "Jam Mulai",
        "controller": jamMulai,
        "placeholder": "Jam Mulai",
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "timepicker",
        "label": "Jam Selesai",
        "controller": jamSelesai,
        "placeholder": "Jam Selesai",
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "text",
        "label": "Nama Kegiatan",
        "placeholder": "Nama Kegiatan",
        "controller": namaKegiatan,
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "text",
        "label": "Permintaan Khusus",
        "placeholder": "Permintaan Khusus",
        "controller": permintaan,
        "maxline": 5,
        "multiText": true
      },
      {
        "type": "text",
        "label": "Nama Pemesan Ruangan",
        "placeholder": "Nama Pemesan Ruangan",
        "controller": nama,
        "maxline": 1,
        "multiText": false
      },
      {
        "type": "text",
        "label": "Kontak Pemesan",
        "placeholder": "Kontak Pemesan",
        "controller": kontak,
        "maxline": 1,
        "multiText": false
      },
    ];
  }

  Future<Map<String, Object>> proceedBooking() async {
    isLoadingList.value = true;
    var status = {"code": 400, "message": "Mohon cek kembali koneksi anda."};
    try {
      print(inputTanggal.value);
      var input = {
        "tanggal":inputTanggal.value,
        "jam_mulai":jamMulai.value,
        "jam_selesai":jamSelesai.value,
        "nama_kegiatan":namaKegiatan.text,
        "permintaan_khusus":permintaan.text,
        "nama_pemesan":nama.text,
        "kontak_pemesan":kontak.text
      };
      final ps = await RuanganService().postData(input);
      if (ps['success']) {
        status = {"code": 200, "message": ""};
        Fluttertoast.showToast(
          msg: "Permintaan booking berhasil dikirim.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Get.back();
      }
    } catch (e) {
      print(e);
    }
    isLoadingList.value = false;
    return status;    
  }
  @override
  void onInit() {
    super.onInit();
    getForm();
  }
}
