import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';
import 'package:masjid_app/models/doa_data.dart';

class ContentDoaController extends GetxController {
  var isLoadingList = true.obs;
  Rx<DoaData> list = Rx(DoaData(
    id: 1,
    judul: '',
    updatedAt: '',
  ));
  var share = "".obs;
  var txtController = TextEditingController();

  String _convertHtmlToText(String htmlString) {
    final document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }

  Future<void> getData() async {
    try {
      isLoadingList.value = true;
      final result = await DoaService().getDetail();

      if (result != null && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        list.value = DoaData(
          id: data['id'],
          judul: data['judul'],
          isi: data['isi'],
          arabic: data['arabic'],
          transliteration: data['transliteration'],
          translations: data['translations'],
          updatedAt: data['updatedAt'],
        );

        final String judul =
            data['judul'] != null ? '${data['judul']}\n\n' : '';
        final String arabic =
            data['arabic'] != null ? '${data['arabic']}\n\n' : '';
        final String transliteration = data['transliteration'] != null
            ? '${_convertHtmlToText(data['transliteration'])}\n\n'
            : '';
        final String translations = data['translations'] != null
            ? '${_convertHtmlToText(data['translations'])}\n\n'
            : '';
        final String isi =
            data['isi'] != null ? '${_convertHtmlToText(data['isi'])}\n\n' : '';

        const String link = 'Dibagikan dari aplikasi\n Marbot App';
        share.value =
            '$judul $arabic $transliteration $translations $isi $link';
      }

      isLoadingList.value = false;
    } catch (e) {
      isLoadingList.value = false;
      if (kDebugMode) {
        debugPrint('<<error controller getcontent doa>>');
        debugPrint(e.toString());
      }
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
