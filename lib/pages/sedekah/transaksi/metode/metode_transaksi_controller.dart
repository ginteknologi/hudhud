import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_service.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';

class MetodeTransaksiController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

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
            "image": "assets/img/pembayaran/linkaja.png",
            "label": "linkAja",
            "type": 2
          },
        ],
      }
    };
  }

  goToNextPage(String id) {
    List<String> keys = dataBillProduct['data'].keys.toList();
    var selected = null;
    for (var k in keys) {
      for (var element in dataBillProduct['data'][k]) {
        if (element['id'] == id) {
          selected = element;
          break;
        }
      }
    }
    if (selected['type'] == 1) {
      procceedPayment('1', selected);
    } else {
      goToEwallet('1', selected);
    }
    // for (var element in tmp) {
    //   // var keys = element.keys;
    //   // for (var subEl in keys) {
    //   print(element);
    // }
  }

  procceedPayment(String id, paramPayment) {
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/status',
        arguments: {"selectedPayment": paramPayment});
  }

  goToEwallet(String id, paramPayment) {
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/payment',
        arguments: {"selectedPayment": paramPayment});
  }

  @override
  void onInit() {
    getBillProduct();
    super.onInit();
  }
}
