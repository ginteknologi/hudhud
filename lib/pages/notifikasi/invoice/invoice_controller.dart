import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_service.dart';

class InvoiceController extends GetxController {
  final authStore = GetStorage();
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listNotif = [].obs;
  final id = Get.parameters['invoice'];
  var dataUser = {};
  String statusInvoice = '';
  Future<void> getData() async {
    final result = await NotifikasiService().getDetailInvoice(id);
    if (result != null) {
      list.value = result['data'];
      if (result['data']['status'] == 'paid') {
        statusInvoice = 'Lunas';
      } else if (result['data']['status'] == 'unpaid') {
        statusInvoice = 'Menunggu Pembayaran';
      } else {
        statusInvoice = 'Dibatalkan';
      }
      dataUser = authStore.read('userLogin');
    }
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
