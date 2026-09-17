import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';
import 'package:masjid_app/models/doaData.dart';

class ContentDoaController extends GetxController {
  var isLoadingList = true.obs;
  Rx<DoaData> list = Rx(DoaData(
    id: 1,
    judul: '',
    updatedAt: '',
  ));
  var share = "".obs;
  // var list = {}.obs;

  var txtController = TextEditingController();
  
  String _convertHtmlToText(String htmlString) {
    var document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }
  Future<void> getData() async {
    try {
      final result = await DoaService().getDetail();
      // list.value = result['data'];
        list.value = DoaData(
            id: result['data']['id'],
            judul: result['data']['judul'],
            isi:result['data']['isi'],
            arabic:result['data']['arabic'],
            transliteration:result['data']['transliteration'],
            translations:result['data']['translations'],
            updatedAt: result['data']['updatedAt']);
      String judul = result['data']['judul'] != null ? result['data']['judul'] + '\n\n':'';
      String arabic = result['data']['arabic'] != null ? result['data']['arabic'] + '\n\n':'';
      String transliteration = result['data']['transliteration'] != null ? '${_convertHtmlToText(result['data']['transliteration'])}\n\n':'';
      String translations = result['data']['translations'] != null ? '${_convertHtmlToText(result['data']['translations'])}\n\n':'';
      String isi = result['data']['isi'] != null ? '${_convertHtmlToText(result['data']['isi'])}\n\n' : '';

      String link = 'Dibagikan dari aplikasi\n Marbot App';
      share.value = '$judul $arabic $transliteration $translations $isi $link';
      isLoadingList.value = false;
    } catch (e) {
      print('<<error controller getcontent doa>>');
      print(e);
    }
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
