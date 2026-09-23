import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/sedekah/detail/detailsedekah_service.dart';
import 'package:masjid_app/routes/sedekah/index.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get_storage/get_storage.dart';

class TransactionSedekahController extends GetxController {
  final dataStore = GetStorage();
  var isLoadingList = true.obs;
  RxBool isLogin = false.obs;
  var userLogin = {}.obs;
  var list = {}.obs;
  List listDonatur = [].obs;
  List denom = [].obs;
  late List<RxBool> denomSelected;
  var txtController = TextEditingController();

  var dataBillProduct = {}.obs;
  RxString inputPembayaran = "".obs;
  var inputAnonymous = false.obs;

  MoneyMaskedTextController inputNominal = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: '.',
    leftSymbol: 'Rp. ',
    rightSymbol: '',
    initialValue: 0,
    precision: 0,
  );
  TextEditingController inputNama = TextEditingController();
  TextEditingController inputNomor = TextEditingController();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPesan = TextEditingController();
  final inputKey = GlobalKey<FormState>();

  void loadStorage() {
    try {
      isLogin.value = dataStore.read('isLogin');
    } catch (e) {
      dataStore.write('isLogin', false);
    }
    try {
      userLogin.value = dataStore.read('userLogin');
    } catch (e) {
      dataStore.write('userLogin', {});
    }
  }

  Future<void> setSedekah(nominal) async {
    inputNominal.text = nominal;
  }

  Future getData() async {
    final result = await DetailSedekahService().getList();
    list.value = result['data'];
    isLoadingList.value = false;
  }

  void goToMetode(String id) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesSedekah.root}/$id/transaksi/metode');
  }

  Future<List<dynamic>> getDenom() async {
    denom = [
      {"id": 1, "label": "Rp. 10.000", "value": "10000"},
      {"id": 2, "label": "Rp. 50.000", "value": "50000"},
      {"id": 3, "label": "Rp. 100.000", "value": "100000"},
    ];
    denomSelected = List.generate(denom.length, (index) => false.obs);
    return denom;
  }

  Map<String, Object> postInput() {
    var status = {
      "code": 400,
      "message": "Mohon untuk di cek kembali data anda."
    };
    if (inputKey.currentState!.validate()) {
      status = {"code": 200, "message": ""};
      final input = {
        "nominal": inputNominal.numberValue,
        'nama': inputNama.text,
        'email': inputEmail.text, // ganti sama email login
        'nomor': inputNomor.text,
        'anonim': inputAnonymous.value,
        'pesan': inputPesan.text,
        'id_campaign': list['id'],
      };
      dataStore.write('inputDataPembayaran', input);
    }
    return status;
  }

  @override
  void onInit() async {
    getData();
    getDenom();
    super.onInit();
  }
}
