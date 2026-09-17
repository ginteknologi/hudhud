import 'package:get/get.dart';
import 'package:masjid_app/routes/sedekah/index.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/pages/sedekah/transaksi/transaksi_sedekah_service.dart';

class MetodeTransaksiController extends GetxController {
  final dataStore = GetStorage();
  var isLoading = true.obs;
  // var dataBillProduct = {}.obs;
  var dataBillProduct = {}.obs;
  RxString inputPembayaran = "".obs;
  RxString inputTypeBayar = "".obs;
  var dataMetodeBayar = {}.obs;

  Future<void> getData() async {
    final result = await TransaksiSedekahServices().getData();
    dataBillProduct.value = result['data'];
    isLoading.value = false;
  }

  void goToMetode(String id) {
    // print(RoutesSedekah.detail, id: id);
    print(id);
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/metode');
  }

  void goToNextPage(String id) {
    final idData = Get.parameters['id'];
    var dataBayar = dataStore.read('inputDataPembayaran');
    dataBayar['idPayment'] = id;
    dataBayar['dataMetodeBayar'] = dataMetodeBayar;
    print(inputTypeBayar.value);
    if (inputTypeBayar.value.toString() == 'va') {
      dataBayar['metode'] = inputTypeBayar.value;
      procceedPayment(idData);
    } else {
      dataBayar['metode'] = inputTypeBayar.value;
      goToEwallet(idData);
    }
  }

  Future<Map<String, Object>> procceedPayment(id) async {
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

  void goToEwallet(id) {
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/payment');
  }

  @override
  void onInit() async {
    // getBillProduct();
    await getData();
    super.onInit();
  }
}
