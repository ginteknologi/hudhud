import 'package:get/get.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/transaksi_sedekah_service.dart';

class MetodeTransaksiController extends GetxController {
  final dataStore = GetStorage();
  var isLoading = true.obs;
  // var dataBillProduct = {}.obs;
  var dataBillProduct = {}.obs;
  RxString inputPembayaran = "".obs;
  RxString inputTypeBayar = "".obs;
  var dataMetodeBayar = {}.obs;

  getData() async {
    final result = await TransaksiSedekahServices().getData();
    dataBillProduct.value = result['data'];
    isLoading.value = false;
  }

  goToMetode(String id) {
    // print(RoutesSedekah.detail, id: id);
    print(id);
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/metode');
  }

  // getBillProduct() {
  //   dataBillProduct.value = {
  //     "data": {
  //       "bank": [
  //         {
  //           "id": "mandiri",
  //           "image": "assets/img/pembayaran/mandiri.png",
  //           "label": "Bank Mandiri",
  //           "type": 1
  //         },
  //         {
  //           "id": "bni",
  //           "image": "assets/img/pembayaran/bni.png",
  //           "label": "Bank BNI",
  //           "type": 1
  //         },
  //         {
  //           "id": "bsi",
  //           "image": "assets/img/pembayaran/bsi.png",
  //           "label": "Bank BSI",
  //           "type": 1
  //         },
  //         {
  //           "id": "bca",
  //           "image": "assets/img/pembayaran/bca.png",
  //           "label": "Bank BCA",
  //           "type": 1
  //         },
  //         {
  //           "id": "bri",
  //           "image": "assets/img/pembayaran/bri.png",
  //           "label": "Bank BRI",
  //           "type": 1
  //         },
  //         {
  //           "id": "permata",
  //           "image": "assets/img/pembayaran/permata.png",
  //           "label": "Permata Bank",
  //           "type": 1
  //         },
  //       ],
  //       "ewallet": [
  //         // {
  //         //   "id": "gopay",
  //         //   "image": "assets/img/pembayaran/gopay.png",
  //         // },
  //         {
  //           "id": "dana",
  //           "image": "assets/img/pembayaran/dana.png",
  //           "label": "Dana",
  //           "type": 2
  //         },
  //         {
  //           "id": "ovo",
  //           "image": "assets/img/pembayaran/ovo.png",
  //           "label": "OVO",
  //           "type": 2
  //         },
  //         {
  //           "id": "linkaja",
  //           "image": "assets/img/pembayaran/linkaja.png",
  //           "label": "LinkAja",
  //           "type": 2
  //         },
  //       ],
  //     }
  //   };
  // }

  goToNextPage(String id) {
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

  goToEwallet(id) {
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/payment');
  }

  @override
  void onInit() async {
    // getBillProduct();
    await getData();
    super.onInit();
  }
}
