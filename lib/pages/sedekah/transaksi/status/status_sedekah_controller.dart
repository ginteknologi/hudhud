import 'package:get/get.dart';
import 'package:masjid_app/pages/sedekah/transaksi/transaksi_sedekah_service.dart';
import 'package:masjid_app/routes/sedekah/index.dart';
import 'package:get_storage/get_storage.dart';

class StatusSedekahController extends GetxController {
  final dataStore = GetStorage();
  var isLoading = true.obs;
  var dataPayment = {}.obs;
  var dataInvoice = {}.obs;

  Future<void> getData() async {
    try {
      var invoiceID = dataStore.read('dataInvoice');
      dataPayment.value = dataStore.read('inputDataPembayaran');
      final result = await TransaksiSedekahServices().getDataInvoice(invoiceID);
      dataInvoice.value = result['data'];
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  void goToMetode(String id) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/metode');
  }

  @override
  void onInit() async {
    // getBillProduct();
    await getData();
    super.onInit();
  }
}
