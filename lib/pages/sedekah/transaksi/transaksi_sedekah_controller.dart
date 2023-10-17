import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_service.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';

class TransactionSedekahController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listDonatur = [].obs;
  List denom = [].obs;
  late List<RxBool> denomSelected;
  var txtController = TextEditingController();

  var dataBillProduct = {}.obs;
  RxString inputPembayaran = "".obs;

  getData() async {
    final result = await SedekahService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  goToMetode(String id) {
    // print(RoutesSedekah.detail, id: id);
    print(id);
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/metode');
  }

  getDenom() async {
    denom = [
      {"id": 1, "label": "Rp. 10.000", "value": 10000},
      {"id": 2, "label": "Rp. 50.000", "value": 50000},
      {"id": 3, "label": "Rp. 100.000", "value": 100000},
    ];
    denomSelected = List.generate(denom.length, (index) => false.obs);
    return denom;
  }

  @override
  void onInit() {
    getDenom();
    super.onInit();
  }
}
