import 'package:get/get.dart';
import 'package:masjid_app/pages/dzikir/dzikir_service.dart';
import 'package:html/parser.dart';

class DzikirController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;

  RxBool flagDzikir = false.obs;

  List listArtikels = [].obs;
  List listCategoryFilter = [].obs;
  List pagi = [].obs;
  List petang = [].obs;
  late List<RxBool> listCategoryFilterSelected;

    String _convertHtmlToText(String htmlString) {
    var document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }
  
  getData() async {
    final results = await DzikirService().getList();
    list.value = results['data'];
    for (Map<String, dynamic> result in results['data']) {
        result['judul'] = result['judul'] != null ? _convertHtmlToText(result['judul']) : '';
        result['arabic'] = result['arabic'] != null ? _convertHtmlToText(result['arabic']) : '';
        result['transliteration'] = result['transliteration'] != null ? _convertHtmlToText(result['transliteration']) : '';
        result['translations'] = result['translations'] != null ? _convertHtmlToText(result['translations']) : '';
        result['isi'] = result['isi'] != null ? _convertHtmlToText(result['isi']) : '';
        result['opening'] = result['opening'] != null ? _convertHtmlToText(result['opening']) : '';
      if (result['idCategoryDoa'] == 60) {
        pagi.add(result);
      } else if (result['idCategoryDoa'] == 61) {
        petang.add(result);
      }
    }
    isLoadingList.value = false;
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
