import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';

class ContentDoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  var share = "".obs;
  List listDoa = [].obs;

  var txtController = TextEditingController();
  
  String _convertHtmlToText(String htmlString) {
    var document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }
  getData() async {
    final result = await DoaService().getDetail();
    list.value = result['data'];
    String judul = result['data']['judul'] != null ? result['data']['judul'] + '\n\n':'';
    String arabic = result['data']['arabic'] != null ? result['data']['arabic'] + '\n\n':'';
    String transliteration = result['data']['transliteration'] != null ? _convertHtmlToText(result['data']['transliteration']) + '\n\n':'';
    String translations = result['data']['translations'] != null ? _convertHtmlToText(result['data']['translations']) + '\n\n':'';
    String isi = result['data']['isi'] != null ? _convertHtmlToText(result['data']['isi']) + '\n\n' : '';

    String link = 'Dibagikan dari aplikasi\n Marbot App';

    share.value =
        '$judul $arabic $transliteration $translations $isi $link';
        print(share);
    isLoadingList.value = false;
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
