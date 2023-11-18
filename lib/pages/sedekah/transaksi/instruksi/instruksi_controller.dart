import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/transaksi_sedekah_service.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';
import 'package:get_storage/get_storage.dart';

class InstruksiController extends GetxController {
  final dataStore = GetStorage();
  var isLoading = true.obs;
  var dataPayment = {}.obs;
  var dataInvoice = {}.obs;
  List dataintruksi = [].obs;

  getData() async {
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

  goToMetode(String id) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/metode');
  }

  getListIntruksi() {
    return dataintruksi = [
      {
        "id": 1,
        "label": "Masukkan kartu ATM dan PIN",
      },
      {
        "id": 1,
        "label": "Pilih menu Bayar/Beli",
      },
      {
        "id": 1,
        "label": "Pilih menu Lainnya, hingga menemukan menu Multipayment",
      },
      {
        "id": 1,
        "label":
            "Masukkan Kode Biller Tokopedia (88708), lalu pilih Benar Masukkan Nomor Virtual Account Tokopedia, lalu pilih tombol Benar",
      },
      {
        "id": 1,
        "label": "Masukkan Angka 1 untuk memilih tagihan, lalu pilih tombol Ya",
      },
      {
        "id": 1,
        "label": "Akan muncul konfirmasi pembayaran, lalu pilih tombol Ya",
      },
      {
        "id": 1,
        "label": "Simpan struk sebagai bukti pembayaran Anda",
      },
    ];
  }

  @override
  void onInit() async {
    // getBillProduct();
    getListIntruksi();
    await getData();
    super.onInit();
  }
}
