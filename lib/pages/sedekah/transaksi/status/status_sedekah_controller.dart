import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/transaksi_sedekah_service.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';
import 'package:get_storage/get_storage.dart';

class StatusSedekahController extends GetxController {
  final dataStore = GetStorage();
  var isLoading = true.obs;
  var dataPayment = {}.obs;
  var dataInvoice = {}.obs;

  var payments = Get.arguments;

  var dataBillProduct = {}.obs;
  RxString inputPembayaran = "".obs;

  getData() async {
    try {
      var invoiceID = dataStore.read('dataInvoice');
      dataPayment.value = dataStore.read('inputDataPembayaran');
      final result = await TransaksiSedekahServices().getDataInvoice(invoiceID);
      dataInvoice.value = result['data'];
      print(dataInvoice);
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  goToMetode(String id) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/metode');
  }

  getBillProduct() {
    dataBillProduct.value = {
      "data": {
        "bank": [
          {
            "id": "mandiri",
            "image": "assets/img/pembayaran/mandiri.png",
            "label": "Bank Mandiri",
            "type": 1
          },
          {
            "id": "bni",
            "image": "assets/img/pembayaran/bni.png",
            "label": "Bank BNI",
            "type": 1
          },
          {
            "id": "bsi",
            "image": "assets/img/pembayaran/bsi.png",
            "label": "Bank BSI",
            "type": 1
          },
          {
            "id": "bca",
            "image": "assets/img/pembayaran/bca.png",
            "label": "Bank BCA",
            "type": 1
          },
          {
            "id": "bri",
            "image": "assets/img/pembayaran/bri.png",
            "label": "Bank BRI",
            "type": 1
          },
          {
            "id": "permata",
            "image": "assets/img/pembayaran/permata.png",
            "label": "Permata Bank",
            "type": 1
          },
        ],
        "ewallet": [
          // {
          //   "id": "gopay",
          //   "image": "assets/img/pembayaran/gopay.png",
          // },
          {
            "id": "dana",
            "image": "assets/img/pembayaran/dana.png",
            "label": "Dana",
            "type": 2
          },
          {
            "id": "ovo",
            "image": "assets/img/pembayaran/ovo.png",
            "label": "OVO",
            "type": 2
          },
          {
            "id": "linkaja",
            "image": "assets/img/pembayaran/ovo.png",
            "label": "linkAja",
            "type": 2
          },
        ],
      }
    };
  }

  @override
  void onInit() async {
    // getBillProduct();
    await getData();
    super.onInit();
  }
}
