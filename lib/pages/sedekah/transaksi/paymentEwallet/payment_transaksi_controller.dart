import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/sedekah/transaksi/transaksi_sedekah_service.dart';
import 'package:masjid_app/routes/sedekah/index.dart';
import 'package:get_storage/get_storage.dart';

class PaymentTransaksiController extends GetxController {
  final dataStore = GetStorage();
  var isLoading = true.obs;
  // var list = {}.obs;

  var dataBillProduct = {}.obs;
  RxString inputPembayaran = "".obs;
  TextEditingController nomorInput = TextEditingController();

  getData() async {
    // final result = await SedekahService().getList();
    // list.value = result['data'];
    dataBillProduct.value = dataStore.read('inputDataPembayaran');
    nomorInput.text = dataBillProduct['nomor'];
    isLoading.value = false;
  }

  procceedPayment(id) async {
    isLoading.value = true;
    var status = {"code": 400, "message": "Mohon cek kembali koneksi anda."};
    try {
      final ps = await TransaksiSedekahServices().postData();
      if (ps['success']) {
        dataStore.write('dataInvoice', ps['data']['invoice']);
        status = {"code": 200, "message": ""};
        Get.offAllNamed('${RoutesSedekah.root}/$id/transaksi/status');
      }
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
    return status;    
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
